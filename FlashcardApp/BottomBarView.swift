//
//  BottomBarView.swift
//  Untitled Project 2
//
//  Created by Alhanouf Sultan on 11/05/1448 AH.
//

import SwiftUI

struct BottomBarView: View {
    var onCategoryTapped: () -> Void
    var onReflectionTapped: () -> Void
    @Binding var selectedTab: String
    
    // مساحة للتحكم بالحركة والانيميشن
    @Namespace private var animationNamespace

    var body: some View {
        HStack(spacing: 70) {
             
            // --- زر القسم الأول (Category) ---
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    selectedTab = "Category"
                }
                onCategoryTapped()
            }) {
                VStack(spacing: 4) {
                    Image(systemName: "book.fill")
                        .font(.system(size: 22))
                    Text("Category")
                        .font(.system(size: 14, weight: .medium))
                }
                .foregroundColor(Color(red: 0.15, green: 0.25, blue: 0.15))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                // إذا كان مختار، نحط له خلفية الكبسولة مع تأثير الحركة والظل
                .background(
                    ZStack {
                        if selectedTab == "Category" {
                            Color(red: 0.15, green: 0.25, blue: 0.15 ).opacity(0.1)
                                        .frame(width: 170, height: 70)
                                        .cornerRadius(40)
                                        .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
                                        .matchedGeometryEffect(id: "activeTab", in: animationNamespace)
                        }
                    }
                )
            }

            // --- زر القسم الثاني (Reflection) ---
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    selectedTab = "Reflection"
                }
                onReflectionTapped()
            }) {
                VStack(spacing: 4) {
                    Image(systemName: "square.and.pencil")
                        .font(.system(size: 22))
                    Text("Refliction")
                        .font(.system(size: 14, weight: .medium))
                }
                .foregroundColor(Color(red: 0.15, green: 0.25, blue: 0.15))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    ZStack {
                        if selectedTab == "Reflection" {
                            Color(red: 0.15, green: 0.25, blue: 0.15 ).opacity(0.1)
                                        .frame(width: 170, height: 70)
                                        .cornerRadius(40)
                                        .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
                                        .matchedGeometryEffect(id: "activeTab", in: animationNamespace)
                        }
                    }
                )
            }

        }
        .padding(.horizontal, 50)
        .padding(.vertical, 12)
        .background(Color(red: 0.95, green: 0.92, blue: 0.82))
        .cornerRadius(57)
        .shadow(color: Color.black.opacity(0.09), radius: 6, x: 0, y: 6)
        
    }
}

// معاينة الشريط
#Preview {
    @Previewable @State var sampleTab = "Category"
    BottomBarView(
        onCategoryTapped: {},
        onReflectionTapped: {},
        selectedTab: $sampleTab
    )
    .padding(.bottom, 8)
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
}
