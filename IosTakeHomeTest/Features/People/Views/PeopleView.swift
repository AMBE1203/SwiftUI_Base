//
//  PeopleView.swift
//  IosTakeHomeTest
//
//  Created by AMBE on 10/11/2022.
//

import SwiftUI

struct PeopleView: View {
    
    
    private let columns = Array(repeating: GridItem(.flexible()), count: 2)
    
    @State private var shouldShowCreate = false
    @StateObject private var vm = PeopleViewModel()
    @State private var shouldShowSuccess = false
    @State private var hasAppeared = false

                                    
    
    var body: some View {
            ZStack {
                backgroundView
                if vm.isLoading {
                    ProgressView()
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(vm.users, id: \.id) { user in
                                NavigationLink {
                                    DetailView(userId: user.id)
                                } label: {
                                    PersonItemView(user: user)
                                        .task {
                                            if vm.hasReachedEnd(of: user) && !vm.isFetching {
                                                await vm.fetchNextSetOfUsers()
                                            }
                                        }
                                }
                            }
                        }
                        .padding()
                    }
                    .refreshable(action: {
                        await vm.fetchUsers()
                    })
                    .overlay(alignment: .bottom) {
                        if vm.isFetching {
                            ProgressView()
                        }
                    }
                }
            }
            .navigationTitle("People")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    creatView
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    refreshView
                }
            }
            .task {
                if !hasAppeared {
                    await vm.fetchUsers()
                    hasAppeared = true
                }
            }
            .sheet(isPresented: $shouldShowCreate) {
                CreateView {
                    haptic(.success)
                    withAnimation(.spring().delay(0.25)){
                        self.shouldShowSuccess.toggle()
                    }
                }
            }
            .alert(isPresented: $vm.hasError,
                   error: vm.error) {
                Button("Retry") {
                    Task {
                        await vm.fetchUsers()
                    }
                }
            }
            .overlay {
                if shouldShowSuccess {
                    CheckmarkPopoverView()
                        .transition(.scale
                                        .combined(with: .opacity))
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                withAnimation(.spring()) {
                                    self.shouldShowSuccess.toggle()
                                }
                            }
                        }
                }
            }
            .embedInNavigation()
    }
}

struct PeopleView_Previews: PreviewProvider {
    static var previews: some View {
        PeopleView()
    }
}

private extension PeopleView {
    
    var backgroundView: some View {
        Theme.background
            .ignoresSafeArea(edges: .top)
    }
    
    var creatView: some View {
        Button {
            shouldShowCreate.toggle()
            
        } label: {
            Symbols.plus
                .font(.system(.headline, design: .rounded).bold())
        }
        .disabled(vm.isLoading)
    }
    
    var refreshView: some View {
        Button {
            Task {
                await vm.fetchUsers()
            }
            
        } label: {
            Symbols.refresh
                .font(.system(.headline, design: .rounded).bold())
        }
        .disabled(vm.isLoading)
    }
}
