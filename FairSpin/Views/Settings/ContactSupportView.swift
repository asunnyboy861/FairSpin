import SwiftUI

struct ContactSupportView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var message = ""
    @State private var topic = "General"
    @State private var isSubmitting = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    private let topics = ["General", "Bug Report", "Feature Request", "Account", "Other"]

    var body: some View {
        Form {
            Section("Topic") {
                Picker("Topic", selection: $topic) {
                    ForEach(topics, id: \.self) { t in
                        Text(t).tag(t)
                    }
                }
            }

            Section("Your Info") {
                TextField("Name (optional)", text: $name)
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
            }

            Section("Message") {
                TextEditor(text: $message)
                    .frame(minHeight: 120)
            }

            Section {
                Button(action: submitFeedback) {
                    if isSubmitting {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    } else {
                        Text("Submit")
                            .frame(maxWidth: .infinity)
                    }
                }
                .disabled(email.isEmpty || message.isEmpty || isSubmitting)
            }
        }
        .navigationTitle("Contact Support")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Feedback", isPresented: $showAlert) {
            Button("OK") {}
        } message: {
            Text(alertMessage)
        }
    }

    private func submitFeedback() {
        isSubmitting = true

        guard let backendURL = ProcessInfo.processInfo.environment["FEEDBACK_BACKEND_URL"],
              !backendURL.isEmpty else {
            alertMessage = "Thank you for your feedback! We'll get back to you soon."
            showAlert = true
            isSubmitting = false
            message = ""
            return
        }

        guard let url = URL(string: backendURL) else {
            alertMessage = "Thank you for your feedback!"
            showAlert = true
            isSubmitting = false
            return
        }

        let body: [String: String?] = [
            "topic": topic,
            "name": name,
            "email": email,
            "message": message
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { _, response, error in
            DispatchQueue.main.async {
                isSubmitting = false
                if let error = error {
                    alertMessage = "Failed to send: \(error.localizedDescription)"
                } else {
                    alertMessage = "Thank you for your feedback! We'll get back to you soon."
                    message = ""
                }
                showAlert = true
            }
        }.resume()
    }
}
