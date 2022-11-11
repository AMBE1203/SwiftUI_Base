//
//  CreateView.swift
//  IosTakeHomeTest
//
//  Created by AMBE on 10/11/2022.
//

import SwiftUI

struct CreateView: View {
    
    
    @Environment(\.dismiss) private var dismiss
//    @FocusState private var focusedField: Field?
    @StateObject private var vm = CreateViewModel()
    let successfulAction: () -> Void
    
    var body: some View {
            Form {
                
                Section {
                    firstNameView
                    lastNameView
                    jobView
                } footer: {
                    if case .validation(let error) = vm.error,
                       let errorDesc = error.errorDescription {
                        Text(errorDesc)
                            .foregroundStyle(.red)
                    }
                }
                

                
                Section {
                    submitBtnView

                }

            }
            .disabled(vm.state == .submitting)
            .navigationTitle("Create")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    doneBtnView
                }
            }
            .onChange(of: vm.state) { newValue in
                if newValue == .successful {
                    dismiss()
                    successfulAction()
                }
            }
            .alert( isPresented: $vm.hasError, error: vm.error) {
                Button("Retry") {
                    Task {
                        await vm.create()
                    }
                }
            }
            .overlay {
                if vm.state == .submitting {
                    ProgressView()
                }
            }
            .embedInNavigation()
    }
}

struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        CreateView {
            
        }
    }
}

private extension CreateView {
    var firstNameView: some View {
        TextField("First name", text: $vm.person.firstName)

    }
    
    var lastNameView: some View {
        TextField("Last name", text: $vm.person.lastName)

    }
    
    var jobView: some View {
        TextField("Job", text: $vm.person.job)

    }
    
    var submitBtnView: some View {
        Button("Submit") {
            Task {
                await vm.create()
            }
        }
    }
    
    var doneBtnView: some View {
        Button("Done") {
            dismiss()
        }
    }
}
