//
//  BookingModal.swift
//  Zodium
//
//  Created by tecH on 26/11/21.
//

import Foundation
struct BookingModal: Codable {
    var booking_id,booking_status,booking_type,coatch_id,duration,is_booking,total_amount,user_id,coatch_amount,gc_id,group_id,total_amunt,total_member,total_group_booking,total_booking,is_rating,price,school_booking_id,school_booking_status,total_minute: Int?
    let  b_date,b_time,course_name : String?
    let created_at,name,profile,coatch_name,group_course_name,start_date,start_time ,group_channel_id,is_time,date,school_group_channel_id  : String?
}



typealias userBookingModal = [BookingModal]
