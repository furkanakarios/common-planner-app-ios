//
//  AddWeddingEntrySheet.swift
//  CommonPlannerApp
//
//  Created by Furkan Akar on 2.02.2026.
//

import SwiftUI
import PhotosUI

struct AddWeddingEntrySheet: View {
    
    let preselectedCategoryId: UUID?

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: WeddingSessionStore
    
    @State private var title: String = ""
    @State private var selectedCategoryId: UUID?
    @State private var priceText: String = ""
    @State private var paymentOption: PaymentOption = .peşin
    @State private var note: String = ""
    @State private var link: String = ""
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var selectedImagesData: [Data] = []
    @State private var pendingCameraShots = 0
    @State private var showContinueShootingDialog = false
    @State private var presentGalleryPicker = false

    @State private var showValidation = false

    var isValid: Bool {
        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return false }
        guard selectedCategoryId != nil else { return false }
        guard parsePrice() != nil else { return false }
        return true
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Zorunlu") {
                    TextField("Başlık", text: $title)

                    Picker("Kategori", selection: Binding(
                        get: { selectedCategoryId ?? store.categories.first?.id },
                        set: { selectedCategoryId = $0 }
                    )) {
                        ForEach(store.categories) { cat in
                            Text(cat.name).tag(cat.id as UUID?)
                        }
                    }

                    TextField("Fiyat (₺)", text: $priceText)
                        .keyboardType(.decimalPad)
                    
                    Picker("Ödeme Seçeneği", selection: $paymentOption) {
                        ForEach(PaymentOption.allCases, id: \.self) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                }

                Section("Opsiyonel") {
                    TextField("Not", text: $note, axis: .vertical)
                        .lineLimit(3, reservesSpace: true)

                    TextField("Link", text: $link)
                        .keyboardType(.URL)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }

                Section("Fotoğraflar (en fazla 5)") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(Array(selectedImagesData.enumerated()), id: \.offset) { index, data in
                                if let uiImage = UIImage(data: data) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 72, height: 72)
                                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                        .overlay(alignment: .topTrailing) {
                                            Button {
                                                selectedImagesData.remove(at: index)
                                                if selectedItems.indices.contains(index) { selectedItems.remove(at: index) }
                                            } label: {
                                                Image(systemName: "xmark.circle.fill")
                                                    .font(.system(size: 14, weight: .bold))
                                                    .symbolRenderingMode(.palette)
                                                    .foregroundStyle(.white, .black.opacity(0.6))
                                                    .background(Circle().fill(Color.black.opacity(0.001)))
                                            }
                                            .offset(x: 4, y: -4)
                                        }
                                }
                            }

                            if selectedImagesData.count < 5 {
                                Menu {
                                    Button {
                                        startCameraFlow()
                                    } label: {
                                        Label("Kameradan Çek", systemImage: "camera")
                                    }
                                    Button {
                                        presentGalleryPicker = true
                                    } label: {
                                        Label("Galeriden Seç", systemImage: "photo")
                                    }
                                } label: {
                                    VStack(spacing: 6) {
                                        Image(systemName: "plus")
                                            .font(.system(size: 18, weight: .semibold))
                                        Text("Ekle")
                                            .font(.footnote.weight(.semibold))
                                    }
                                    .frame(width: 72, height: 72)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                                            .fill(Color(.tertiarySystemFill))
                                    )
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }

                if showValidation && !isValid {
                    Section {
                        Text("Lütfen Başlık, Kategori ve geçerli bir Fiyat gir.")
                            .foregroundStyle(.red)
                            .font(.footnote)
                    }
                }
            }
            .navigationTitle("Seçenek Ekle")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Vazgeç") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Kaydet") {
                        guard let categoryId = selectedCategoryId ?? store.categories.first?.id else { return }
                        guard let price = parsePrice() else {
                            showValidation = true
                            return
                        }
                        let entry = WeddingEntry(
                            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                            categoryId: categoryId,
                            price: price,
                            paymentOption: paymentOption,
                            note: note.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : note,
                            link: link.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : link,
                            photos: selectedImagesData,
                            status: .candidate
                        )
                        store.addEntry(entry)
                        dismiss()
                    }
                }
            }
            .onAppear {
                if selectedCategoryId == nil {
                    // 1) Eğer ekrandan bir kategori seçili gelmişse onu kullan
                    if let pre = preselectedCategoryId,
                       store.categories.contains(where: { $0.id == pre }) {
                        selectedCategoryId = pre
                    } else {
                        // 2) Yoksa ilk kategoriye düş
                        selectedCategoryId = store.categories.first?.id
                    }
                }
            }
            .onChange(of: selectedItems) { oldValue, newValue in
                Task {
                    for item in newValue.suffix(5 - selectedImagesData.count) {
                        if let data = try? await item.loadTransferable(type: Data.self) {
                            if selectedImagesData.count < 5 { selectedImagesData.append(data) }
                        }
                    }
                }
            }
            .photosPicker(isPresented: $presentGalleryPicker, selection: $selectedItems, maxSelectionCount: 5 - selectedImagesData.count, matching: .images)
            .sheet(isPresented: $isShowingCamera) {
                CameraView(isPresented: $isShowingCamera) { image in
                    handleCapturedImage(image)
                    if selectedImagesData.count < 5 {
                        // Kullanıcıya devam etmek isteyip istemediğini sor
                        pendingCameraShots += 1
                        if pendingCameraShots < 5 {
                            showContinueShootingDialog = true
                        }
                    }
                }
            }
            .confirmationDialog("Devam etmek ister misiniz?", isPresented: $showContinueShootingDialog, titleVisibility: .visible) {
                Button("Bir Fotoğraf Daha Çek") {
                    if selectedImagesData.count < 5 {
                        presentCamera()
                    }
                }
                Button("Bitir", role: .cancel) {
                    pendingCameraShots = 0
                }
            }
        }
    }

    private func parsePrice() -> Decimal? {
        let trimmed = priceText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }

        // TR: virgül destek
        let normalized = trimmed.replacingOccurrences(of: ",", with: ".")
        return Decimal(string: normalized)
    }

    @State private var isShowingCamera = false

    private func presentCamera() {
        #if targetEnvironment(simulator)
        // Simülatörde kamera yok, PhotosPicker kullanımını teşvik ediyoruz
        return
        #else
        isShowingCamera = true
        #endif
    }

    private func handleCapturedImage(_ image: UIImage) {
        if let data = image.jpegData(compressionQuality: 0.85) {
            if selectedImagesData.count < 5 { selectedImagesData.append(data) }
        }
    }

    private func startGalleryFlow() {
        selectedItems = []
        presentGalleryPicker = true
    }

    private func startCameraFlow() {
        #if targetEnvironment(simulator)
        // Simülatörde kamera yok
        #else
        presentCamera()
        #endif
    }
}
private struct CameraView: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    var onImage: (UIImage) -> Void

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CameraView
        init(_ parent: CameraView) { self.parent = parent }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.onImage(image)
            }
            parent.isPresented = false
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isPresented = false
        }
    }
}

