//
//  CategoryButtonView.swift
//  MyApp
//
//  Created by Alhanouf Sultan on 11/05/1448 AH.
//

import SwiftUI

struct CategoryButtonView: View {
    let title: String
    //let subtitle:String
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            HStack {
                           
                            VStack(alignment: .leading, spacing: 4) {
                                Text(title)
                                    .font(.system(size: 21, weight: .bold))
                                    .foregroundColor(Color(red: 0.15, green: 0.25, blue: 0.15))
                                
                            }
                            
                            Spacer()
                            
                            // سهم الانتقال على اليمين
                            Image(systemName: "chevron.right")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(Color(red: 0.15, green: 0.25, blue: 0.15))
                        }
                       // .padding(.horizontal, 0)
                        .foregroundStyle(Color("PrimaryGreen"))
                        .padding(.horizontal, 20)
                       
                        .frame(height: 40)
                        .padding(.vertical, 28)
                        .frame(maxWidth: .infinity, alignment: .leading)
            //Card collor
                        .background(Color("Cream"), in: RoundedRectangle(cornerRadius: 28))
                      //  .cornerRadius(20)
                        .shadow(color: .black.opacity(0.16), radius: 8, y: 6)

                        .contentShape(RoundedRectangle(cornerRadius: 28))
                        
                    }
        .padding(.horizontal, 20)
        .padding(.vertical, 4)
                }
        }
    

#Preview {
    CategoryButtonView(title: "The Micro-Validation",action: {})
}
