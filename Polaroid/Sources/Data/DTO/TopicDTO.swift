//
//  TopicDTO.swift
//  Polaroid
//
//  Created by gnksbm on 7/23/24.
//

import Foundation

struct TopicDTO: Decodable {
    let id, slug: String
    let alternativeSlugs: AlternativeSlugs
    let createdAt: String
    let updatedAt: String
    let promotedAt: String?
    let width, height: Int
    let color: String
    let blurHash: String?
    let description: String?
    let altDescription: String
//    let breadcrumbs: [Any]
    let urls: Urls
    let links: Link
    let likes: Int
    let likedByUser: Bool
//    let currentUserCollections: [Any]
//    let sponsorship: Any?
    let topicSubmissions: TopicSubmissions
    let assetType: AssetType
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
//        case breadcrumbs, 
        case urls, links, likes
        case likedByUser = "liked_by_user"
//        case currentUserCollections = "current_user_collections"
//        case sponsorship
        case topicSubmissions = "topic_submissions"
        case assetType = "asset_type"
        case user
    }
}

extension TopicDTO {
    func toTopicImage() -> TopicImage {
        TopicImage(
            id: id,
            imageURL: URL(string: urls.small),
            likeCount: likes
        )
    }
}

extension TopicDTO {
    struct AlternativeSlugs: Codable {
        let en, es, ja, fr: String
        let it, ko, de, pt: String
    }
    
    enum AssetType: String, Codable {
        case photo = "photo"
    }
    
    struct Link: Codable {
        let linksSelf, html, download, downloadLocation: String
        
        enum CodingKeys: String, CodingKey {
            case linksSelf = "self"
            case html, download
            case downloadLocation = "download_location"
        }
    }
    
    struct TopicSubmissions: Codable {
        let architectureInterior: ArchitectureInterior?
        let spirituality, travel: BusinessWork?
        let goldenHour: ArchitectureInterior?
        let wallpapers, businessWork, experimental: BusinessWork?
        let texturesPatterns: BusinessWork?
        let film: ArchitectureInterior?
        
        enum CodingKeys: String, CodingKey {
            case architectureInterior = "architecture-interior"
            case spirituality, travel
            case goldenHour = "golden-hour"
            case wallpapers
            case businessWork = "business-work"
            case experimental
            case texturesPatterns = "textures-patterns"
            case film
        }
    }
    
    struct ArchitectureInterior: Codable {
        let status: String
        let approvedOn: String?
        
        enum CodingKeys: String, CodingKey {
            case status
            case approvedOn = "approved_on"
        }
    }
    
    struct BusinessWork: Codable {
        let status: String
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
        let paypalEmail: String?
        
        enum CodingKeys: String, CodingKey {
            case instagramUsername = "instagram_username"
            case portfolioURL = "portfolio_url"
            case twitterUsername = "twitter_username"
            case paypalEmail = "paypal_email"
        }
    }
}
