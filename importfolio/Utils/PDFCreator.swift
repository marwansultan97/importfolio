//
//  PDFCreator.swift
//  importfolio
//
//  Created by Marwan Osama on 12/10/2021.
//

import Foundation
import TPPDF



class PDFCreator {
    
    
    func createResume(userModel: UserModel, completion: @escaping(URL?, Error?) -> Void) {
        let doc = PDFDocument(format: .a4)
        DispatchQueue.global().async {
            self.createHeader(doc: doc, userModel: userModel)
            self.createProfessionalSummary(doc: doc, userModel: userModel)
            self.createEducations(doc: doc, userModel: userModel)
            self.createExperiences(doc: doc, userModel: userModel)
            self.createSkills(doc: doc, userModel: userModel)
            self.createProjects(doc: doc, userModel: userModel)
            
            do {
                let generator = PDFGenerator(document: doc)
                let url = try generator.generateURL(filename: "example.pdf")
                DispatchQueue.main.async {
                    print(url)
                    completion(url, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    print(error)
                    completion(nil, error)
                }
                
            }
        }
        
        
    }
    
    private func createHeader(doc: PDFDocument, userModel: UserModel) {
        let profileImage = getImageFromUrl(urlString: userModel.personalInfo.image ?? "")
        let profileImagePDF = PDFImage(image: profileImage,
                                caption: nil,
                                size: CGSize(width: 70, height: 70),
                                sizeFit: .widthHeight,
                                quality: 1,
                                options: .rounded,
                                cornerRadius: 30)
        
        let name = NSMutableAttributedString(string: userModel.personalInfo.fullname, attributes: [
            .font: UIFont.systemFont(ofSize: 30, weight: .bold),
            .foregroundColor: UIColor.thirdAppColor
        ])
        
        let jobTitle = NSMutableAttributedString(string: userModel.personalInfo.jobTitle ?? "", attributes: [
            .font: UIFont.systemFont(ofSize: 27, weight: .semibold),
            .foregroundColor: UIColor.black
        ])
        
        let line = PDFLineStyle(type: .full, color: .darkGray, width: 1)
        
        doc.add(.contentLeft, image: profileImagePDF)
        doc.add(space: 5)
        doc.add(attributedText: name)
        doc.add(attributedText: jobTitle)
        doc.add(space: 8)
        doc.addLineSeparator(style: line)
        doc.add(space: 8)
        
        let place = NSMutableAttributedString(string: "\(userModel.personalInfo.country) \(String(describing: userModel.personalInfo.city ?? ""))", attributes: [
            .font: UIFont.systemFont(ofSize: 17, weight: .regular),
            .foregroundColor: UIColor.black
        ])
        let phone = NSMutableAttributedString(string: userModel.personalInfo.phone, attributes: [
            .font: UIFont.systemFont(ofSize: 17, weight: .regular),
            .foregroundColor: UIColor.black
        ])
        let email = NSMutableAttributedString(string: userModel.personalInfo.email, attributes: [
            .font: UIFont.systemFont(ofSize: 17, weight: .regular),
            .foregroundColor: UIColor.black
        ])
        let linkedin = NSMutableAttributedString(string: userModel.personalInfo.linkedin ?? "", attributes: [
            .font: UIFont.systemFont(ofSize: 17, weight: .regular),
            .foregroundColor: UIColor.black
        ])
        
        doc.add(attributedText: place)
        doc.add(space: 2)
        doc.add(attributedText: phone)
        doc.add(space: 2)
        doc.add(attributedText: email)
        doc.add(space: 2)
        doc.add(attributedText: linkedin)
        doc.add(space: 10)
    }
    
    private func createProfessionalSummary(doc: PDFDocument, userModel: UserModel) {
        guard let summary = userModel.personalInfo.summary, !summary.isEmpty else { return }
        
        let staticProfessionalSummary = NSMutableAttributedString(string: "Professional Summary", attributes: [
            .font: UIFont.systemFont(ofSize: 22, weight: .bold),
            .foregroundColor: UIColor.thirdAppColor
        ])
        
        let summaryPDF = NSMutableAttributedString(string: summary, attributes: [
            .font: UIFont.systemFont(ofSize: 16, weight: .regular),
            .foregroundColor: UIColor.black
        ])
        
        doc.add(attributedText: staticProfessionalSummary)
        doc.add(space: 5)
        doc.add(attributedText: summaryPDF)
        doc.add(space: 15)
    }
    
    private func createEducations(doc: PDFDocument, userModel: UserModel) {
        guard !userModel.educations.isEmpty else { return }
        
        let staticEducations = NSMutableAttributedString(string: "Educations", attributes: [
            .font: UIFont.systemFont(ofSize: 22, weight: .bold),
            .foregroundColor: UIColor.thirdAppColor
        ])
        
        doc.add(attributedText: staticEducations)
        doc.add(space: 5)

        
        for education in userModel.educations {
            let placeName = NSMutableAttributedString(string: education.university, attributes: [
                .font: UIFont.systemFont(ofSize: 16, weight: .semibold),
                .foregroundColor: UIColor.black
            ])
            
            let degreeName = NSMutableAttributedString(string: education.degreeLevel, attributes: [
                .font: UIFont.systemFont(ofSize: 15, weight: .regular),
                .foregroundColor: UIColor.black.withAlphaComponent(0.8)
            ])
            
            let fromAndTo = NSMutableAttributedString(string: "\(education.from) - \(education.to)", attributes: [
                .font: UIFont.systemFont(ofSize: 15, weight: .regular),
                .foregroundColor: UIColor.black.withAlphaComponent(0.8)
            ])
            
            doc.add(attributedText: placeName)
            doc.add(space: 2)
            doc.add(attributedText: degreeName)
            doc.add(space: 2)
            doc.add(attributedText: fromAndTo)
            doc.add(space: 5)
        }
        
        doc.add(space: 10)
    }
    
    
    private func createExperiences(doc: PDFDocument, userModel: UserModel) {
        guard !userModel.experiences.isEmpty else { return }
        
        let staticExperiences = NSMutableAttributedString(string: "Experiences", attributes: [
            .font: UIFont.systemFont(ofSize: 22, weight: .bold),
            .foregroundColor: UIColor.thirdAppColor
        ])
        
        doc.add(attributedText: staticExperiences)

        for experience in userModel.experiences {
            
            let title = NSMutableAttributedString(string: "\(experience.title) at \(experience.company)", attributes: [
                .font: UIFont.systemFont(ofSize: 16, weight: .semibold),
                .foregroundColor: UIColor.black
            ])
            
            let fromAndToJob = NSMutableAttributedString(string: "    \(experience.fromMonth) \(experience.fromYear) - \(experience.toMonth) \(experience.toYear)", attributes: [
                .font: UIFont.systemFont(ofSize: 16, weight: .regular),
                .foregroundColor: UIColor.black.withAlphaComponent(0.7)
            ])
            
            let final = NSMutableAttributedString()
            final.append(title)
            final.append(fromAndToJob)
            
            let jobDesc = NSMutableAttributedString(string: experience.description, attributes: [
                .font: UIFont.systemFont(ofSize: 15, weight: .regular),
                .foregroundColor: UIColor.black.withAlphaComponent(0.8)
            ])
            
            doc.add(space: 5)
            doc.add(attributedText: final)
            doc.add(space: 7)
            doc.add(attributedText: jobDesc)
            doc.add(space: 10)
        }
        
        
        doc.add(space: 10)
    }
    
    private func createSkills(doc: PDFDocument, userModel: UserModel) {
        guard !userModel.skills.isEmpty else { return }
        
        let staticSkills = NSMutableAttributedString(string: "Skills", attributes: [
            .font: UIFont.systemFont(ofSize: 22, weight: .bold),
            .foregroundColor: UIColor.thirdAppColor
        ])
        
        doc.add(attributedText: staticSkills)
        doc.add(space: 5)
        
        for skill in userModel.skills {
            let skillPDF = NSMutableAttributedString(string: "- \(skill.skill)", attributes: [
                .font: UIFont.systemFont(ofSize: 15, weight: .regular),
                .foregroundColor: UIColor.black
            ])
            
            doc.add(attributedText: skillPDF)
            doc.add(space: 3)
        }
        
        doc.add(space: 15)
    }
    
    private func createProjects(doc: PDFDocument, userModel: UserModel) {
        guard !userModel.projects.isEmpty else { return }
        
        let staticProjects = NSMutableAttributedString(string: "Projects", attributes: [
            .font: UIFont.systemFont(ofSize: 22, weight: .bold),
            .foregroundColor: UIColor.thirdAppColor
        ])
        
        doc.add(attributedText: staticProjects)
        doc.add(space: 10)
        
        for project in userModel.projects {
            let projectImage = getImageFromUrl(urlString: project.appImage)
            let projectImagePDF = PDFImage(image: projectImage,
                                        caption: nil,
                                        size: CGSize(width: 40, height: 40),
                                        sizeFit: .widthHeight,
                                        quality: 1,
                                        options: .rounded,
                                        cornerRadius: 20)
            
            let projectName = NSMutableAttributedString(string: project.name, attributes: [
                .font: UIFont.systemFont(ofSize: 16, weight: .semibold),
                .foregroundColor: UIColor.black
            ])
            
            let projectCategory = NSMutableAttributedString(string: "    \(project.category)", attributes: [
                .font: UIFont.systemFont(ofSize: 16, weight: .regular),
                .foregroundColor: UIColor.black.withAlphaComponent(0.8)
            ])
            
            let projectTextPDF = NSMutableAttributedString()
            projectTextPDF.append(projectName)
            projectTextPDF.append(projectCategory)
            
            let projectDesc = NSMutableAttributedString(string: project.description, attributes: [
                .font: UIFont.systemFont(ofSize: 14, weight: .regular),
                .foregroundColor: UIColor.black
            ])
            
            let techUsed = NSMutableAttributedString(string: "Technologies Used: \(project.technologies)", attributes: [
                .font: UIFont.systemFont(ofSize: 14, weight: .regular),
                .foregroundColor: UIColor.black
            ])
            
            let projectLink = NSMutableAttributedString(string: "Project Link: \(project.github)", attributes: [
                .font: UIFont.systemFont(ofSize: 14, weight: .regular),
                .foregroundColor: UIColor.black
            ])
            
            
            doc.add(image: projectImagePDF)
            doc.add(attributedText: projectTextPDF)
            doc.add(space: 2)
            doc.add(attributedText: projectDesc)
            doc.add(space: 2)
            doc.add(attributedText: techUsed)
            doc.add(space: 2)
            doc.add(attributedText: projectLink)
            doc.add(space: 15)
        }
    }
    
    private func getImageFromUrl(urlString: String) -> UIImage {
        if let url = URL(string: urlString), let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
            return image
        }
        return UIImage()
    }
    
}
