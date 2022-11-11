//
//  DetailView.swift
//  IosTakeHomeTest
//
//  Created by AMBE on 10/11/2022.
//

import SwiftUI

struct DetailView: View {
    
    let userId: Int
    @StateObject private var vm = DetailViewModel()
    
    var body: some View {
        ZStack {
            background
            if vm.isLoading {
                ProgressView()
            } else {
                ScrollView {
                    VStack(alignment: .leading,
                           spacing: 18) {
                        
                        avatarView
                        
                        Group {
                            generalView
                            linkView
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 18)
                        .background(Theme.detailBackground, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                    
                    }
                           .padding()
                }

            }
            
        }
        .navigationTitle("Details")
        .task {
            await vm.fetchDetails(for: userId)

        }
        .alert( isPresented: $vm.hasError, error: vm.error) {
            Button("Retry") {
                Task {
                    await vm.fetchDetails(for: userId)
                }
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    
    private static var previewUserId: Int {
        let users = try! StaticJSONMapper.decode(file: "UserStaticData", type: UserResponse.self)
        
        return users.data.first!.id
    }
    
    static var previews: some View {
        DetailView(userId: previewUserId)
            .embedInNavigation()
    }
}

private extension DetailView {
    var background: some View {
        Theme.background
            .ignoresSafeArea(edges: .top)
    }
    
    @ViewBuilder
    var avatarView: some View {
        if let avatarAbsoluteString = vm.userInfo?.data.avatar,
           let avatarUrl = URL(string: avatarAbsoluteString) {
            AsyncImage(url: avatarUrl) { image in
                image
                    .resizable()
                    .aspectRatio( contentMode: .fill)
                    .frame(height: 250)
                    .clipped()
                
            } placeholder: {
                ProgressView()
            }
            .clipShape(RoundedRectangle(cornerRadius: 16,
                                        style: .continuous))
        }
    }
    
    @ViewBuilder
    var linkView: some View {
        
        if let supportAbsoluteString = vm.userInfo?.support.url,
           let supportUrl = URL(string: supportAbsoluteString),
           let supportTxt = vm.userInfo?.support.text {
            Link(destination: supportUrl) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(supportTxt)
                        .foregroundColor(Theme.text)
                        .font(
                            .system(.body, design: .rounded)
                                .weight(.semibold)
                        )
                        .multilineTextAlignment(.leading)
                    Text(supportAbsoluteString)
                }
                Spacer()
                
                Symbols
                    .link
                    .font(.system(.title3, design: .rounded))
            }
        }
        
    }
    
    var generalView: some View {
        
        VStack(alignment: .leading,
           spacing: 8) {
            PillView(id: vm.userInfo?.data.id ?? 0)
        
            Group {
                firstNameView
                lastNameView
                emailView
            }
            .foregroundColor(Theme.text)
        }


    }
    
    @ViewBuilder
    var firstNameView: some View {
        Text("First name")
            .font(
                .system(.body, design: .rounded)
                    .weight(.semibold)
            )
        
        Text(vm.userInfo?.data.firstName ?? "-")
            .font(
                .system(.subheadline, design: .rounded)
            )
        
        Divider()
    }
    
    @ViewBuilder
    var lastNameView: some View {
        Text("Last name")
            .font(
                .system(.body, design: .rounded)
                    .weight(.semibold)
            )
        
        Text(vm.userInfo?.data.lastName ?? "-")
            .font(
                .system(.subheadline, design: .rounded)
            )
        
        Divider()
    }
    
    @ViewBuilder
    var emailView: some View {
        Text("Email")
            .font(
                .system(.body, design: .rounded)
                    .weight(.semibold)
            )
        
        Text(vm.userInfo?.data.email ?? "-")
            .font(
                .system(.subheadline, design: .rounded)
            )
    }
}
