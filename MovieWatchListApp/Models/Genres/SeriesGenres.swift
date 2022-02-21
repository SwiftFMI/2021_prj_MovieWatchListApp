//
//  SeriesGenres.swift
//  MovieWatchListApp
//
//  Created by Admin on 21.02.22.
//

import Foundation

struct SeriesGenres {
    static var seriesGenres: [Genre] = Utilities.readGenres(fileName: "seriesGenres")
}
