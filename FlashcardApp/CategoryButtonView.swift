//
//  CategoryButtonView.swift
//  MyApp
//
//  Created by Alhanouf Sultan on 11/05/1448 AH.
//

import SwiftUI

struct CategoryButtonView: View {
    let title: String
    let subtitle:String
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            HStack {
                           
                            VStack(alignment: .leading, spacing: 4) {
                                Text(title)
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(Color(red: 0.15, green: 0.25, blue: 0.15))
                                
                                Text(subtitle)
                                    .font(.system(size: 13))
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            // سهم الانتقال على اليمين
                            Image(systemName: "chevron.right")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(Color(red: 0.15, green: 0.25, blue: 0.15))
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 24)
                        // خلفية البطاقة الفاتحة مع الحواف الدائرية
                        .background(Color(red: 0.98, green: 0.96, blue: 0.88))
                        .cornerRadius(20)
                        // الحدود/الإطار الخارجي الأخضر الناعم للبطاقة
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color(red: 0.3, green: 0.4, blue: 0.2, opacity: 0.5), lineWidth: 1.5)
                        )
                        // إمكانية إضافة ظل خفيف تحته
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)
                    }
        .padding(.horizontal, 20)
        .padding(.vertical, 4)
                }
        }
    

#Preview {
    CategoryButtonView(title: "The Micro-Validation",
                       subtitle: "Start Conversation with confidence.",
                       action: {})
}
