//
//  Constants.swift
//  importfolio
//
//  Created by Marwan Osama on 03/09/2021.
//

import UIKit


let SCREEN_WIDTH = UIScreen.main.bounds.width
let SCREEN_HEIGHT = UIScreen.main.bounds.height

let COUNTRY_LIST = Locale.isoRegionCodes.compactMap { Locale.current.localizedString(forRegionCode: $0) }

let GENDERS = ["Male", "Female"]

let APP_CATEGORY_LIST = ["E-Commerce","Education","Financial Services","Healthcare","Hosting Services","Marketing & Sales","Social Media","Shopping","Travel","Lifestyle","Games/Entertainment","Utility","News/Information","Food/Drink"]

let DAYS = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31"]
let MONTHS = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
let YEARS = ["2022","2021","2020","2019","2018","2017","2016","2015","2014","2013","2012","2011","2010","2009","2008","2007","2006","2005","2004","2003","2002","2001","2000","1999","1998","1997","1996","1995","1994","1993","1992","1991","1990","1989","1988","1987","1986","1985","1984","1983","1982","1981","1980"]


let DEGREE_LEVELS = ["Bachelor's Degree", "Master's Degree", "MBA", "Doctorate's Degree", "Vocational", "Technical Diploma", "College Diploma", "Other"]

let GRADES = ["A / Excellent / 85 - 100%",
              "B / Very Good / 75 - 85%",
              "C / Good / 65 - 75%",
              "D / Fair / 50 - 65%"]

