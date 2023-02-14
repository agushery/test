//
//  RemoteImageView.swift
//  Movies
//
//  Created by Agus Hery on 13/02/23.
//  Copyright © 2023 Agus Hery. All rights reserved.
//

import SwiftUI

struct RemoteImageView: View {
    
    var url: String?
    
    var body: some View {
        if let url = url {
            AsyncImage(url: URL(string: API.baseIMGURL+url)) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
        } else {
            Text("Not Found")
        }
    }
}

struct RemoteImageView_Previews: PreviewProvider {
    static var previews: some View {
        RemoteImageView(url: MovieModel.dummyData.posterPath!)
    }
}
