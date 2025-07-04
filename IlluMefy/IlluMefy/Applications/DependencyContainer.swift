//
//  DependencyContainer.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/03/20.
//  Updated on 2025/04/04.
//

import Swinject

final class DependencyContainer: @unchecked Sendable {
    static let shared = DependencyContainer()
    let container = Container()
    
    private init() {
        makeConcreteObjects()
        registerRepositories()
        registerUseCases()
        registerViewModels()
    }
    
    func resolve<T>(_ serviceType: T.Type) -> T? {
        return container.resolve(serviceType)
    }
    ///
    /// make concrete type of objects
    ///
    private func makeConcreteObjects() {
        // the concrete type of UserLocalSettingsDataSource
        container.register(UserLocalSettingsDataSource.self) { _ in
            UserLocalSettingsDataSource()
        }.inObjectScope(.container)
        // the concrete type of PhoneAuthRepository
        container.register(PhoneAuthRepository.self) { _ in
            PhoneAuthRepository() // デフォルトでFirebasePhoneAuthProvider()が使われる
        }.inObjectScope(.container)
        // the concrete type of UserPreferencesRepository
        container.register(UserPreferencesRepository.self) { resolver in
            let userLocalSettingsDataSource = resolver.resolve(UserLocalSettingsDataSource.self)!
            return UserPreferencesRepository(userLocalSettingsDataSource: userLocalSettingsDataSource)
        }.inObjectScope(.container)
        // the concrete type of MockCreatorRepository
        container.register(MockCreatorRepository.self) { _ in
            MockCreatorRepository()
        }.inObjectScope(.container)
        
        // TagApplication repository
        container.register(TagApplicationRepository.self) { _ in
            TagApplicationRepository()
        }.inObjectScope(.container)
        
        // ProfileCorrection repository
        container.register(ProfileCorrectionRepository.self) { _ in
            ProfileCorrectionRepository()
        }.inObjectScope(.container)
        
        container.register(MockProfileCorrectionRepository.self) { _ in
            MockProfileCorrectionRepository()
        }.inObjectScope(.container)
        
        // SearchHistory repository
        container.register(SearchHistoryRepository.self) { _ in
            SearchHistoryRepository()
        }.inObjectScope(.container)
        
        // Tag repository
        container.register(MockTagRepository.self) { _ in
            MockTagRepository()
        }.inObjectScope(.container)
        
        // Favorite repository
        container.register(FavoriteRepository.self) { _ in
            FavoriteRepository()
        }.inObjectScope(.container)
        
        // OperatorMessage repository
        container.register(OperatorMessageRepository.self) { _ in
            OperatorMessageRepository()
        }.inObjectScope(.container)
        
        // ContactSupport repository
        container.register(ContactSupportRepository.self) { _ in
            ContactSupportRepository()
        }.inObjectScope(.container)
        
        // Auth repository
        container.register(AuthRepository.self) { _ in
            AuthRepository()
        }.inObjectScope(.container)
    }
    ///
    /// register all repositories
    ///
    private func registerRepositories() {
        // UserLocalSettingsDataSource repository
        container.register(UserLocalSettingsDataSourceProtocol.self) { resolver in
            resolver.resolve(UserLocalSettingsDataSource.self)!
        }.inObjectScope(.transient)
        // UserPreferences repository
        container.register(UserPreferencesRepositoryProtocol.self) { resolver in
            resolver.resolve(UserPreferencesRepository.self)!
        }.inObjectScope(.transient)
        // PhoneAuth repository
        container.register(PhoneAuthRepositoryProtocol.self) { resolver in
            resolver.resolve(PhoneAuthRepository.self)!
        }.inObjectScope(.transient)
        // Creator repository
        container.register(CreatorRepositoryProtocol.self) { resolver in
            resolver.resolve(MockCreatorRepository.self)!
        }.inObjectScope(.transient)
        
        // TagApplication repository
        container.register(TagApplicationRepositoryProtocol.self) { resolver in
            resolver.resolve(TagApplicationRepository.self)!
        }.inObjectScope(.transient)
        
        // ProfileCorrection repository
        container.register(ProfileCorrectionRepositoryProtocol.self) { resolver in
            resolver.resolve(MockProfileCorrectionRepository.self)!
        }.inObjectScope(.transient)
        
        // SearchHistory repository
        container.register(SearchHistoryRepositoryProtocol.self) { resolver in
            resolver.resolve(SearchHistoryRepository.self)!
        }.inObjectScope(.transient)
        
        // Tag repository
        container.register(TagRepositoryProtocol.self) { resolver in
            resolver.resolve(MockTagRepository.self)!
        }.inObjectScope(.transient)
        
        // Favorite repository
        container.register(FavoriteRepositoryProtocol.self) { resolver in
            resolver.resolve(FavoriteRepository.self)!
        }.inObjectScope(.transient)
        
        // OperatorMessage repository
        container.register(OperatorMessageRepositoryProtocol.self) { resolver in
            resolver.resolve(OperatorMessageRepository.self)!
        }.inObjectScope(.transient)
        
        // ContactSupport repository
        container.register(ContactSupportRepositoryProtocol.self) { resolver in
            resolver.resolve(ContactSupportRepository.self)!
        }.inObjectScope(.transient)
        
        // Auth repository
        container.register(AuthRepositoryProtocol.self) { resolver in
            resolver.resolve(AuthRepository.self)!
        }.inObjectScope(.transient)
    }
    ///
    /// register all usecases
    ///
    private func registerUseCases() {
        // SendPhoneVerification usecase
        container.register(SendPhoneVerificationUseCase.self) { resolver in
            let phoneAuthRepository = resolver.resolve(PhoneAuthRepositoryProtocol.self)!
            return SendPhoneVerificationUseCase(phoneAuthRepository: phoneAuthRepository)
        }.inObjectScope(.transient)
        
        // VerifyPhoneAuthCode usecase
        container.register(VerifyPhoneAuthCodeUseCase.self) { resolver in
            let phoneAuthRepository = resolver.resolve(PhoneAuthRepositoryProtocol.self)!
            return VerifyPhoneAuthCodeUseCase(phoneAuthRepository: phoneAuthRepository)
        }.inObjectScope(.transient)
        
        // Protocol registrations for use cases
        container.register((any SendPhoneVerificationUseCaseProtocol).self) { resolver in
            resolver.resolve(SendPhoneVerificationUseCase.self)!
        }.inObjectScope(.transient)
        
        container.register((any VerifyPhoneAuthCodeUseCaseProtocol).self) { resolver in
            resolver.resolve(VerifyPhoneAuthCodeUseCase.self)!
        }.inObjectScope(.transient)
        
        // GetPopularCreators usecase
        container.register(GetPopularCreatorsUseCase.self) { resolver in
            let creatorRepository = resolver.resolve(CreatorRepositoryProtocol.self)!
            return GetPopularCreatorsUseCase(creatorRepository: creatorRepository)
        }.inObjectScope(.transient)
        
        container.register((any GetPopularCreatorsUseCaseProtocol).self) { resolver in
            resolver.resolve(GetPopularCreatorsUseCase.self)!
        }.inObjectScope(.transient)
        
        // SearchCreatorsByTags usecase
        container.register(SearchCreatorsByTagsUseCase.self) { resolver in
            let creatorRepository = resolver.resolve(CreatorRepositoryProtocol.self)!
            return SearchCreatorsByTagsUseCase(creatorRepository: creatorRepository)
        }.inObjectScope(.transient)
        
        container.register((any SearchCreatorsByTagsUseCaseProtocol).self) { resolver in
            resolver.resolve(SearchCreatorsByTagsUseCase.self)!
        }.inObjectScope(.transient)
        
        // GetCreatorDetail usecase
        container.register(GetCreatorDetailUseCase.self) { resolver in
            let creatorRepository = resolver.resolve(CreatorRepositoryProtocol.self)!
            return GetCreatorDetailUseCase(creatorRepository: creatorRepository)
        }.inObjectScope(.transient)
        
        container.register((any GetCreatorDetailUseCaseProtocol).self) { resolver in
            resolver.resolve(GetCreatorDetailUseCase.self)!
        }.inObjectScope(.transient)
        
        // SubmitTagApplication usecase
        container.register(SubmitTagApplicationUseCase.self) { resolver in
            let tagApplicationRepository = resolver.resolve(TagApplicationRepositoryProtocol.self)!
            let creatorRepository = resolver.resolve(CreatorRepositoryProtocol.self)!
            return SubmitTagApplicationUseCase(
                tagApplicationRepository: tagApplicationRepository,
                creatorRepository: creatorRepository
            )
        }.inObjectScope(.transient)
        
        container.register((any SubmitTagApplicationUseCaseProtocol).self) { resolver in
            resolver.resolve(SubmitTagApplicationUseCase.self)!
        }.inObjectScope(.transient)
        
        // SubmitProfileCorrection usecase
        container.register(SubmitProfileCorrectionUseCase.self) { resolver in
            let profileCorrectionRepository = resolver.resolve(ProfileCorrectionRepositoryProtocol.self)!
            let creatorRepository = resolver.resolve(CreatorRepositoryProtocol.self)!
            return SubmitProfileCorrectionUseCase(
                profileCorrectionRepository: profileCorrectionRepository,
                creatorRepository: creatorRepository
            )
        }.inObjectScope(.transient)
        
        container.register((any SubmitProfileCorrectionUseCaseProtocol).self) { resolver in
            resolver.resolve(SubmitProfileCorrectionUseCase.self)!
        }.inObjectScope(.transient)
        
        // SearchCreatorsByName usecase
        container.register(SearchCreatorsByNameUseCase.self) { resolver in
            let creatorRepository = resolver.resolve(CreatorRepositoryProtocol.self)!
            return SearchCreatorsByNameUseCase(creatorRepository: creatorRepository)
        }.inObjectScope(.transient)
        
        container.register((any SearchCreatorsByNameUseCaseProtocol).self) { resolver in
            resolver.resolve(SearchCreatorsByNameUseCase.self)!
        }.inObjectScope(.transient)
        
        // SaveSearchHistory usecase
        container.register(SaveSearchHistoryUseCase.self) { resolver in
            let searchHistoryRepository = resolver.resolve(SearchHistoryRepositoryProtocol.self)!
            return SaveSearchHistoryUseCase(repository: searchHistoryRepository)
        }.inObjectScope(.transient)
        
        // GetSearchHistory usecase
        container.register(GetSearchHistoryUseCase.self) { resolver in
            let searchHistoryRepository = resolver.resolve(SearchHistoryRepositoryProtocol.self)!
            return GetSearchHistoryUseCase(repository: searchHistoryRepository)
        }.inObjectScope(.transient)
        
        // ClearSearchHistory usecase
        container.register(ClearSearchHistoryUseCase.self) { resolver in
            let searchHistoryRepository = resolver.resolve(SearchHistoryRepositoryProtocol.self)!
            return ClearSearchHistoryUseCase(searchHistoryRepository: searchHistoryRepository)
        }.inObjectScope(.transient)
        
        // GetFavoriteCreators usecase
        container.register((any GetFavoriteCreatorsUseCaseProtocol).self) { resolver in
            let favoriteRepository = resolver.resolve(FavoriteRepositoryProtocol.self)!
            let creatorRepository = resolver.resolve(CreatorRepositoryProtocol.self)!
            return GetFavoriteCreatorsUseCase(
                favoriteRepository: favoriteRepository,
                creatorRepository: creatorRepository
            )
        }.inObjectScope(.transient)
        
        // SearchTagsByName usecase
        container.register(SearchTagsByNameUseCase.self) { resolver in
            let tagRepository = resolver.resolve(TagRepositoryProtocol.self)!
            return SearchTagsByNameUseCase(tagRepository: tagRepository)
        }.inObjectScope(.transient)
        
        container.register((any SearchTagsByNameUseCaseProtocol).self) { resolver in
            resolver.resolve(SearchTagsByNameUseCase.self)!
        }.inObjectScope(.transient)
        
        // GetOperatorMessage usecase
        container.register(GetOperatorMessageUseCase.self) { resolver in
            let operatorMessageRepository = resolver.resolve(OperatorMessageRepositoryProtocol.self)!
            return GetOperatorMessageUseCase(operatorMessageRepository: operatorMessageRepository)
        }.inObjectScope(.transient)
        
        container.register((any GetOperatorMessageUseCaseProtocol).self) { resolver in
            resolver.resolve(GetOperatorMessageUseCase.self)!
        }.inObjectScope(.transient)
        
        // SubmitContactSupport usecase
        container.register(SubmitContactSupportUseCase.self) { resolver in
            let contactSupportRepository = resolver.resolve(ContactSupportRepositoryProtocol.self)!
            return SubmitContactSupportUseCase(repository: contactSupportRepository)
        }.inObjectScope(.transient)
        
        container.register((any SubmitContactSupportUseCaseProtocol).self) { resolver in
            resolver.resolve(SubmitContactSupportUseCase.self)!
        }.inObjectScope(.transient)
        
        // GetContactSupportHistory usecase
        container.register(GetContactSupportHistoryUseCase.self) { resolver in
            let contactSupportRepository = resolver.resolve(ContactSupportRepositoryProtocol.self)!
            return GetContactSupportHistoryUseCase(repository: contactSupportRepository)
        }.inObjectScope(.transient)
        
        container.register((any GetContactSupportHistoryUseCaseProtocol).self) { resolver in
            resolver.resolve(GetContactSupportHistoryUseCase.self)!
        }.inObjectScope(.transient)
        
        // Logout usecase
        container.register(LogoutUseCase.self) { resolver in
            let authRepository = resolver.resolve(AuthRepositoryProtocol.self)!
            return LogoutUseCase(authRepository: authRepository)
        }.inObjectScope(.transient)
        
        container.register((any LogoutUseCaseProtocol).self) { resolver in
            resolver.resolve(LogoutUseCase.self)!
        }.inObjectScope(.transient)
        
        // DeleteAccount usecase
        container.register(DeleteAccountUseCase.self) { resolver in
            let authRepository = resolver.resolve(AuthRepositoryProtocol.self)!
            let favoriteRepository = resolver.resolve(FavoriteRepositoryProtocol.self)!
            let userPreferencesRepository = resolver.resolve(UserPreferencesRepositoryProtocol.self)!
            return MainActor.assumeIsolated {
                return DeleteAccountUseCase(
                    authRepository: authRepository,
                    favoriteRepository: favoriteRepository,
                    userPreferencesRepository: userPreferencesRepository
                )
            }
        }.inObjectScope(.transient)
        
        container.register((any DeleteAccountUseCaseProtocol).self) { resolver in
            resolver.resolve(DeleteAccountUseCase.self)!
        }.inObjectScope(.transient)
        
    }
    ///
    /// register all view-models
    ///
    private func registerViewModels() {
        // PhoneRegistration screen
        container.register(PhoneNumberRegistrationViewModel.self) { resolver in
            let sendPhoneVerificationUseCase = resolver.resolve((any SendPhoneVerificationUseCaseProtocol).self)!
            return MainActor.assumeIsolated {
                return PhoneNumberRegistrationViewModel(
                    sendPhoneVerificationUseCase: sendPhoneVerificationUseCase
                )
            }
        }.inObjectScope(.transient)
        
        // Home screen
        container.register(HomeViewModel.self) { resolver in
            let getPopularCreatorsUseCase = resolver.resolve((any GetPopularCreatorsUseCaseProtocol).self)!
            let searchCreatorsByTagsUseCase = resolver.resolve((any SearchCreatorsByTagsUseCaseProtocol).self)!
            let getOperatorMessageUseCase = resolver.resolve((any GetOperatorMessageUseCaseProtocol).self)!
            return MainActor.assumeIsolated {
                return HomeViewModel(
                    getPopularCreatorsUseCase: getPopularCreatorsUseCase,
                    searchCreatorsByTagsUseCase: searchCreatorsByTagsUseCase,
                    getOperatorMessageUseCase: getOperatorMessageUseCase
                )
            }
        }.inObjectScope(.transient)
        
        container.register((any HomeViewModelProtocol).self) { resolver in
            resolver.resolve(HomeViewModel.self)!
        }.inObjectScope(.transient)
        
        // CreatorDetail screen
        container.register(CreatorDetailViewModel.self) { (resolver, creatorId: String) in
            let getCreatorDetailUseCase = resolver.resolve((any GetCreatorDetailUseCaseProtocol).self)!
            let favoriteRepository = resolver.resolve(FavoriteRepositoryProtocol.self)!
            return MainActor.assumeIsolated {
                return CreatorDetailViewModel(
                    creatorId: creatorId,
                    getCreatorDetailUseCase: getCreatorDetailUseCase,
                    favoriteRepository: favoriteRepository
                )
            }
        }.inObjectScope(.transient)
        
        // TagApplication screen
        container.register(TagApplicationViewModel.self) {(resolver, creator: Creator, applicationType: TagApplicationRequest.ApplicationType) in
            let submitTagApplicationUseCase = resolver.resolve((any SubmitTagApplicationUseCaseProtocol).self)!
            return MainActor.assumeIsolated {
                return TagApplicationViewModel(
                    creator: creator,
                    applicationType: applicationType,
                    submitTagApplicationUseCase: submitTagApplicationUseCase
                )
            }
        }.inObjectScope(.transient)
        
        // ProfileCorrection screen
        container.register(ProfileCorrectionViewModel.self) { (resolver, creator: Creator) in
            let submitProfileCorrectionUseCase = resolver.resolve((any SubmitProfileCorrectionUseCaseProtocol).self)!
            return MainActor.assumeIsolated {
                return ProfileCorrectionViewModel(
                    creator: creator,
                    submitProfileCorrectionUseCase: submitProfileCorrectionUseCase
                )
            }
        }.inObjectScope(.transient)
        
        // Search screen
        container.register(SearchViewModel.self) { resolver in
            let searchTagsByNameUseCase = resolver.resolve((any SearchTagsByNameUseCaseProtocol).self)!
            let searchCreatorsByTagsUseCase = resolver.resolve((any SearchCreatorsByTagsUseCaseProtocol).self)!
            let saveSearchHistoryUseCase = resolver.resolve(SaveSearchHistoryUseCase.self)!
            let getSearchHistoryUseCase = resolver.resolve(GetSearchHistoryUseCase.self)!
            let clearSearchHistoryUseCase = resolver.resolve(ClearSearchHistoryUseCase.self)!
            return MainActor.assumeIsolated {
                return SearchViewModel(
                    searchTagsByNameUseCase: searchTagsByNameUseCase,
                    searchCreatorsByTagsUseCase: searchCreatorsByTagsUseCase,
                    saveSearchHistoryUseCase: saveSearchHistoryUseCase,
                    getSearchHistoryUseCase: getSearchHistoryUseCase,
                    clearSearchHistoryUseCase: clearSearchHistoryUseCase
                )
            }
        }.inObjectScope(.transient)
        
        // Favorite screen
        container.register(FavoriteViewModel.self) { resolver in
            let getFavoriteCreatorsUseCase = resolver.resolve((any GetFavoriteCreatorsUseCaseProtocol).self)!
            let favoriteRepository = resolver.resolve(FavoriteRepositoryProtocol.self)!
            return MainActor.assumeIsolated {
                return FavoriteViewModel(
                    getFavoriteCreatorsUseCase: getFavoriteCreatorsUseCase,
                    favoriteRepository: favoriteRepository
                )
            }
        }.inObjectScope(.transient)
        
        // Account screen
        container.register(AccountViewModel.self) { resolver in
            let deleteAccountUseCase = resolver.resolve((any DeleteAccountUseCaseProtocol).self)!
            return MainActor.assumeIsolated {
                return AccountViewModel(deleteAccountUseCase: deleteAccountUseCase)
            }
        }.inObjectScope(.transient)
        
        // Setting screen
        container.register(SettingViewModel.self) { resolver in
            let getOperatorMessageUseCase = resolver.resolve((any GetOperatorMessageUseCaseProtocol).self)!
            let logoutUseCase = resolver.resolve((any LogoutUseCaseProtocol).self)!
            return MainActor.assumeIsolated {
                return SettingViewModel(getOperatorMessageUseCase: getOperatorMessageUseCase, logoutUseCase: logoutUseCase)
            }
        }.inObjectScope(.transient)
        
        container.register((any FavoriteViewModelProtocol).self) { resolver in
            resolver.resolve(FavoriteViewModel.self)!
        }.inObjectScope(.transient)
        
        // ContactSupport screen
        container.register(ContactSupportViewModel.self) { resolver in
            let submitContactSupportUseCase = resolver.resolve((any SubmitContactSupportUseCaseProtocol).self)!
            return MainActor.assumeIsolated {
                return ContactSupportViewModel(submitContactSupportUseCase: submitContactSupportUseCase)
            }
        }.inObjectScope(.transient)
    }
}
