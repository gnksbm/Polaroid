//
//  SearchDTO.swift
//  Polaroid
//
//  Created by gnksbm on 7/26/24.
//

import Foundation

struct SearchDTO: Codable {
    let total, totalPages: Int
    let results: [Result]

    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case results
    }
}

extension SearchDTO {
    func toSearchedImage() -> ([LikableImage], page: Int) {
        let images = results.map { result in
            LikableImage(
                id: result.urls.small,
                imageURL: URL(string: result.urls.small),
                likeCount: result.likes,
                isLiked: false,
                color: result.color
            )
        }
        return (images, totalPages)
    }
}

extension SearchDTO {
    struct Result: Codable {
        let id, slug: String
        let alternativeSlugs: AlternativeSlugs
        let createdAt, updatedAt: String
        let promotedAt: String?
        let width, height: Int
        let color: String
        let blurHash: String?
        let description: String?
        let altDescription: String?
        let breadcrumbs: [Breadcrumb]
        let urls: Urls
        let links: ResultLinks
        let likes: Int
        let likedByUser: Bool
//        let currentUserCollections: [Any]
//        let sponsorship: Any?
        let topicSubmissions: ResultTopicSubmissions
        let assetType: String
        let user: User
        let tags: [Tag]
        
        enum CodingKeys: String, CodingKey {
            case id, slug
            case alternativeSlugs = "alternative_slugs"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
            case promotedAt = "promoted_at"
            case width, height, color
            case blurHash = "blur_hash"
            case description
            case altDescription = "alt_description"
            case breadcrumbs, urls, links, likes
            case likedByUser = "liked_by_user"
//            case currentUserCollections = "current_user_collections"
//            case sponsorship
            case topicSubmissions = "topic_submissions"
            case assetType = "asset_type"
            case user, tags
        }
    }
    
    struct AlternativeSlugs: Codable {
        let en, es, ja, fr: String
        let it, ko, de, pt: String
    }
    
    struct ResultLinks: Codable {
        let linksSelf, html, download, downloadLocation: String
        
        enum CodingKeys: String, CodingKey {
            case linksSelf = "self"
            case html, download
            case downloadLocation = "download_location"
        }
    }
    
    struct Tag: Codable {
        let type: TypeEnum
        let title: String
        let source: Source?
    }
    
    struct Source: Codable {
        let ancestry: Ancestry
        let title, subtitle: String
        let description: String?
        let metaTitle: String
        let metaDescription: String
        let coverPhoto: CoverPhoto
        
        enum CodingKeys: String, CodingKey {
            case ancestry, title, subtitle, description
            case metaTitle = "meta_title"
            case metaDescription = "meta_description"
            case coverPhoto = "cover_photo"
        }
    }
    
    struct Ancestry: Codable {
        let type, category: Category?
        let subcategory: Category?
    }
    
    struct Category: Codable {
        let slug, prettySlug: String
        
        
        enum CodingKeys: String, CodingKey {
            case slug
            case prettySlug = "pretty_slug"
        }
    }
    
    struct CoverPhoto: Codable {
        let id, slug: String
        let alternativeSlugs: AlternativeSlugs
        let createdAt, updatedAt: String
        let promotedAt: String?
        let width, height: Int
        let color: String
        let blurHash: String?
        let description: String?
        let altDescription: String?
        let breadcrumbs: [Breadcrumb]
        let urls: Urls
        let links: ResultLinks
        let likes: Int
        let likedByUser: Bool
//        let currentUserCollections: [JSONAny]
//        let sponsorship: JSONNull?
        let topicSubmissions: CoverPhotoTopicSubmissions
        let assetType: String
        let premium, plus: Bool?
        let user: User
        
        enum CodingKeys: String, CodingKey {
            case id, slug
            case alternativeSlugs = "alternative_slugs"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
            case promotedAt = "promoted_at"
            case width, height, color
            case blurHash = "blur_hash"
            case description
            case altDescription = "alt_description"
            case breadcrumbs
            case urls, links, likes
            case likedByUser = "liked_by_user"
//            case currentUserCollections = "current_user_collections"
//            case sponsorship
            case topicSubmissions = "topic_submissions"
            case assetType = "asset_type"
            case premium, plus, user
        }
    }
    
    struct Breadcrumb: Codable {
        let slug, title: String
        let index: Int
        let type: TypeEnum
    }
    
    enum TypeEnum: String, Codable {
        case landingPage = "landing_page"
        case search = "search"
    }
    
    struct CoverPhotoTopicSubmissions: Codable {
        let texturesPatterns, wallpapers, health: HealthClass?
        let architectureInterior, nature: HealthClass?
        
        enum CodingKeys: String, CodingKey {
            case texturesPatterns = "textures-patterns"
            case wallpapers, health
            case architectureInterior = "architecture-interior"
            case nature
        }
    }
    
    struct HealthClass: Codable {
        let status: String
        let approvedOn: String?
        
        enum CodingKeys: String, CodingKey {
            case status
            case approvedOn = "approved_on"
        }
    }
    
    struct Urls: Codable {
        let raw, full, regular, small: String
        let thumb, smallS3: String
        
        enum CodingKeys: String, CodingKey {
            case raw, full, regular, small, thumb
            case smallS3 = "small_s3"
        }
    }
    
    struct User: Codable {
        let id: String
        let updatedAt: String
        let username, name, firstName: String
        let lastName, twitterUsername: String?
        let portfolioURL: String?
        let bio, location: String?
        let links: UserLinks
        let profileImage: ProfileImage
        let instagramUsername: String?
        let totalCollections, totalLikes, totalPhotos, totalPromotedPhotos: Int
        let totalIllustrations, totalPromotedIllustrations: Int
        let acceptedTos, forHire: Bool
        let social: Social
        
        enum CodingKeys: String, CodingKey {
            case id
            case updatedAt = "updated_at"
            case username, name
            case firstName = "first_name"
            case lastName = "last_name"
            case twitterUsername = "twitter_username"
            case portfolioURL = "portfolio_url"
            case bio, location, links
            case profileImage = "profile_image"
            case instagramUsername = "instagram_username"
            case totalCollections = "total_collections"
            case totalLikes = "total_likes"
            case totalPhotos = "total_photos"
            case totalPromotedPhotos = "total_promoted_photos"
            case totalIllustrations = "total_illustrations"
            case totalPromotedIllustrations = "total_promoted_illustrations"
            case acceptedTos = "accepted_tos"
            case forHire = "for_hire"
            case social
        }
    }
    
    struct UserLinks: Codable {
        let linksSelf, html, photos, likes: String
        let portfolio, following, followers: String
        
        enum CodingKeys: String, CodingKey {
            case linksSelf = "self"
            case html, photos, likes, portfolio, following, followers
        }
    }
    
    struct ProfileImage: Codable {
        let small, medium, large: String
    }
    
    struct Social: Codable {
        let instagramUsername: String?
        let portfolioURL: String?
        let twitterUsername: String?
//        let paypalEmail: Any?
        
        enum CodingKeys: String, CodingKey {
            case instagramUsername = "instagram_username"
            case portfolioURL = "portfolio_url"
            case twitterUsername = "twitter_username"
//            case paypalEmail = "paypal_email"
        }
    }
    
    struct ResultTopicSubmissions: Codable {
        let film, goldenHour, architectureInterior: BusinessWorkClass?
        let businessWork: BusinessWorkClass?
        let nature, streetPhotography, travel, wallpapers: BusinessWorkClass?
        
        enum CodingKeys: String, CodingKey {
            case film
            case goldenHour = "golden-hour"
            case architectureInterior = "architecture-interior"
            case businessWork = "business-work"
            case nature
            case streetPhotography = "street-photography"
            case travel, wallpapers
        }
    }
    
    struct BusinessWorkClass: Codable {
        let status: String
    }
}
