//
//  RandomDTO.swift
//  Polaroid
//
//  Created by gnksbm on 7/25/24.
//

import Foundation

struct RandomDTO: Decodable {
    let id, slug: String
    let alternativeSlugs: AlternativeSlugs
    let createdAt, updatedAt, promotedAt: String
    let width, height: Int
    let color: String
    let blurHash: String?
    let description: String?
    let altDescription: String?
    let breadcrumbs: [Breadcrumb]
    let urls: Urls
    let links: WelcomeLinks
    let likes: Int
    let likedByUser: Bool
//    let currentUserCollections: [Any]
//    let sponsorship: Any?
    let topicSubmissions: TopicSubmissions
    let assetType: String
    let user: User
    let exif: Exif
    let location: Location
    let views, downloads: Int

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
//        case currentUserCollections = "current_user_collections"
//        case sponsorship
        case topicSubmissions = "topic_submissions"
        case assetType = "asset_type"
        case user, exif, location, views, downloads
    }
}

extension RandomDTO {
    func toRandomImage() -> RandomImage {
        RandomImage(
            id: id,
            imageURL: URL(string: urls.regular),
            creatorProfileImageURL: URL(string: user.profileImage.small),
            creatorName: user.name,
            creatorAt: createdAt.iso8601Formatted()
        )
    }
}

struct AlternativeSlugs: Decodable {
    let en, es, ja, fr: String
    let it, ko, de, pt: String
}

struct Breadcrumb: Decodable {
    let slug, title: String
    let index: Int
    let type: String
}

struct Exif: Decodable {
    let make, model, name, exposureTime: String?
    let aperture, focalLength: String?
    let iso: Int?

    enum CodingKeys: String, CodingKey {
        case make, model, name
        case exposureTime = "exposure_time"
        case aperture
        case focalLength = "focal_length"
        case iso
    }
}

struct WelcomeLinks: Decodable {
    let linksSelf, html, download, downloadLocation: String

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case html, download
        case downloadLocation = "download_location"
    }
}

struct Location: Decodable {
    let name: String?
//    let city: Any?
    let country: String?
    let position: Position
}

struct Position: Decodable {
    let latitude, longitude: Double?
}

struct TopicSubmissions: Decodable {
    let the3DRenders, nature: The3_DRenders?
    let spirituality, travel, wallpapers: ArchitectureInterior?
    let fashionBeauty, streetPhotography: The3_DRenders?
    let architectureInterior, businessWork: ArchitectureInterior?

    enum CodingKeys: String, CodingKey {
        case the3DRenders = "3d-renders"
        case nature, spirituality, travel, wallpapers
        case fashionBeauty = "fashion-beauty"
        case streetPhotography = "street-photography"
        case architectureInterior = "architecture-interior"
        case businessWork = "business-work"
    }
}

// MARK: - ArchitectureInterior
struct ArchitectureInterior: Decodable {
    let status: String
}

struct The3_DRenders: Decodable {
    let status: String
    let approvedOn: String?

    enum CodingKeys: String, CodingKey {
        case status
        case approvedOn = "approved_on"
    }
}

struct Urls: Decodable {
    let raw, full, regular, small: String
    let thumb, smallS3: String

    enum CodingKeys: String, CodingKey {
        case raw, full, regular, small, thumb
        case smallS3 = "small_s3"
    }
}

struct User: Decodable {
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

struct UserLinks: Decodable {
    let linksSelf, html, photos, likes: String
    let portfolio, following, followers: String

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case html, photos, likes, portfolio, following, followers
    }
}

struct ProfileImage: Decodable {
    let small, medium, large: String
}

struct Social: Decodable {
    let instagramUsername: String?
    let portfolioURL: String?
    let twitterUsername: String?
//    let paypalEmail: Any?

    enum CodingKeys: String, CodingKey {
        case instagramUsername = "instagram_username"
        case portfolioURL = "portfolio_url"
        case twitterUsername = "twitter_username"
//        case paypalEmail = "paypal_email"
    }
}
