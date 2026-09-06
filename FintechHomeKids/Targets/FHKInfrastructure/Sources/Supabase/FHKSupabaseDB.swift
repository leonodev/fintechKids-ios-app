//
//  FHKSupabaseDB.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 31/8/26.
//

public struct FHK_SUPABASE_DB {
    
    public struct TABLE_FAMILIES {
        public static let NAME: String = "fhk_families"
        
        public struct COLUMN {
            public static let createdAt = "created_at"
            public static let nameFamily = "name_family"
            public static let emailParent = "email_parent"
            public static let approvePin = "approve_pin"
        }
        
        public static let SELECT_FAMILY_INFO = """
                    approve_pin,
                    name_family
                    """
    }
    
    public struct TABLE_FAMILY_MEMBER {
        public static let NAME: String = "fhk_family_members"
        
        public struct COLUMN {
            public static let email = "email_parent"
            public static let memberName = "member_name"
            public static let avatarName = "avatar_name"
            public static let identificationUUID = "identification_uuid"
        }
    }
    
    public struct TABLE_TASK {
        public static let NAME: String = "fhk_task_list"
        
        public struct COLUMN {
            public static let name = "name"
            public static let timeGranted = "time_granted"
            public static let coinsGranted = "coins_granted"
            public static let email = "email_parent"
        }
    }
    
    public struct TABLE_GOAL {
        public static let NAME: String = "fhk_goals_list"
        
        public struct COLUMN {
            public static let id = "id"
            public static let dateExpiration = "date_expiration"
            public static let name = "name"
            public static let emailParent = "email_parent"
            public static let value = "value"
            public static let measure_type = "measure_type"
            public static let status = "status"
        }
    }
    
    public struct TABLE_BALANCE {
        public static let NAME: String = "fhk_members_balance"
        
        public struct COLUMN {
            public static let memberId = "member_id"
            public static let coinsObtained = "coins_obtained"
            public static let timeObtained = "time_obtained"
        }
        
        public struct FUNCTION_RPC {
            public static let updateCoinsBalance = "update_coins_balance"
            public static let updateTimeBalance = "update_time_balance"
        }
    }
    
    public struct TABLE_REWARDS_LIST {
        public static let NAME: String = "fhk_rewards_list"
        
        public struct COLUMN {
            public static let createdAt = "created_at"
            public static let name = "name"
            public static let timeRequiered = "time_requiered"
            public static let coinsRequired = "coins_required"
            public static let emailParent = "email_parent"
        }
    }
    
    public struct TABLE_REWARDS_COLLECTED{
        public static let NAME: String = "fhk_rewards_collected"
        
        public struct COLUMN {
            public static let createdAt = "created_at"
            public static let memberId = "member_id"
            public static let parentEmail = "parent_email"
            public static let nameReward = "name_reward"
            public static let claimedValue = "claimed_value"
            public static let state = "state"
            public static let nameTask = "name_task"
        }

        public static let JOIN_FAMILY_MEMBER = """
            *,
            member:fhk_family_members (
                email_parent,
                identification_uuid,
                member_name,
                avatar_name,
                name_family
            )
            """
    }
    
    public struct TABLE_GOALS_MEMBER {
        public static let NAME: String = "fhk_goals_members"
        
        public struct COLUMN {
            public static let createdAt = "created_at"
            public static let goalId = "goal_id"
            public static let memberId = "member_id"
            public static let nameGoal = "name_goal"
            public static let rewardsSystemValue = "rewards_system_value"
            public static let accumulatedValue = "accumulated_value"
            public static let rewardsSystemType = "rewards_system_type"
            public static let parentEmail = "parent_email"
        }
        
        public struct FUNCTION_EDGE {
            public static let upsertGoalMember = "upsert-goal-member"
        }
    }
}
