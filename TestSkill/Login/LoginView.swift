import SwiftUI
import LocalAuthentication

struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel
    
    init(){
        print("init Login Page")
        viewModel = LoginViewModel()
    }
    
    
    var touchOrFaceID : some View {
        VStack{
            if self.viewModel.getBioMetricStatus(){
             
                Circle()
                    .fill(Color("green"))
                    .frame(width: 70, height: 70)
                    .overlay(
                        Image(systemName: LAContext().biometryType == .faceID ? "faceid" : "touchid")
                            .frame(width: 70, height: 70)
                            .aspectRatio(contentMode: ContentMode.fill)
                            .font(.title)
                            .foregroundColor(.black)
                            .background(Color("green"))
                            .clipShape(Circle())
                    )
                    .shadow(radius: 5)
                    .onTapGesture {
                        self.viewModel.authenticateUser()
                    }
            
            }else{
                EmptyView()
            }
        }
    }
    
    var body: some View {
        VStack {
           upperArea()
           loginArea
           loginButton
            Text("----or-----")
                .font(MainFont.forPlaceHolder())
                .foregroundColor(Color.textColor)
            HStack{
                facebookButton
                googleButton
                appleButton
                touchOrFaceID
                Spacer()
            }.padding()
            
            VStack{
                EmptyView()
                    .fullScreenCover(isPresented: self.$viewModel.showRegisterPage){
                        RegisterPage(closeFlag: self.$viewModel.showRegisterPage)
                    }
                EmptyView()
                    .fullScreenCover(isPresented: self.$viewModel.showForgetPassword){
                        LazyView(ForgetPasswordView(closeFlag: self.$viewModel.showForgetPassword))
                    }
            }
        }.alert(isPresented: self.$viewModel.showAlertForFaceID, content: {
            Alert(title: Text("Message"), message: Text("Store Information For Future Login Using BioMetric Authentication ???"), primaryButton: .default(Text("Accept"), action: {
//                self.viewModel.Stored_Info = true
                self.viewModel.Stored_User = self.viewModel.email
                self.viewModel.Stored_Password = self.viewModel.password
                self.viewModel.Stored_LoginType = "Nomarl"
                self.viewModel.normalLogin()
            }), secondaryButton: .cancel({
//                self.viewModel.Stored_Info = false
                self.viewModel.Stored_User = ""
                self.viewModel.Stored_Password = ""
                self.viewModel.normalLogin()
            }))
        })
        
        
    }
    
    var loginButton : some View{
        HStack{
            Button(action: {
//                print("Stored_Info" ,self.viewModel.Stored_Info)
//                if self.viewModel.Stored_Info == false {
//                    self.viewModel.normalLogin()
//                }else{
                    withAnimation{self.viewModel.showAlertForFaceID = true}
//                }
            }){
                HStack(alignment: .center) {
                    Text("Login")
                        .textStyle(size: 16 , color: Color.white)
                        .frame(maxWidth:.infinity)
                }.padding()
            }
            .background(Color.greenColor)
            .padding()
            .shadow(radius: 5)
        }
    }

    var loginArea : some View{
        VStack{
            TextField("Email", text: $viewModel.email)
                .font(MainFont.forPlaceHolder())
                .padding()
                .cornerRadius(10)
                .background(SwiftUI.Color.whiteGaryColor)
            .autocapitalization(.none)

            SecureField("Password", text: $viewModel.password)
                .font(MainFont.forPlaceHolder())
                .padding()
                .cornerRadius(10)
                .background(SwiftUI.Color.whiteGaryColor)
            .autocapitalization(.none)
//
            HStack{
                Text("Register Account")
                    .font(MainFont.forPlaceHolder())
                    .foregroundColor(SwiftUI.Color.redColor)
                    .onTapGesture {
                        withAnimation {                       
                            self.viewModel.showRegisterPage = true
//                            self.isShow = true
                        }
                    }
                Spacer()
                Text("Forget Password")
                    .font(MainFont.forPlaceHolder())
                    .foregroundColor(SwiftUI.Color.redColor)
                .onTapGesture {
                    withAnimation {
                        self.viewModel.showForgetPassword = true
                    }
                }
            }
            .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
        }
//        .keyboardResponsive()
        .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
    }
    
    func upperArea() -> some View {
        VStack{
            PageView(viewModel.sampleDataForPageView).equatable()
//                .aspectRatio(contentMode: ContentMode.fit)

            Text("Vietnam Mahjong")
                .foregroundColor(SwiftUI.Color.textColor)
                .font(MainFont.forTitleText())
            Text("少賭宜情 大賭李家誠")
//                .font(MainFont.bold.size(16))
            .titleStyle()
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                .foregroundColor(SwiftUI.Color.textColor)
        }
    }
    
    var googleButton : some View {
        Circle()
            .fill(SwiftUI.Color.init(red: 219/255, green: 68/255, blue: 55/255))
            .frame(width: 50, height: 50)
            .overlay(
                Image("icon-google")
                    .resizable()
                    .aspectRatio(contentMode: ContentMode.fit)
                    .frame(width: 30, height: 30)
        ).shadow(radius: 5)
            .onTapGesture {
                SocialLogin().attemptLoginGoogle()
        }
    }
    
    var facebookButton : some View {
        Circle()
            .fill(SwiftUI.Color.init(red: 59/255, green: 89/255, blue: 152/255))
            .frame(width: 50, height: 50)
            .overlay(
                Image("icon-facebook")
                    .resizable()
                    .aspectRatio(contentMode: ContentMode.fit)
                    .frame(width: 50, height: 50)
        ).shadow(radius: 5)
        .onTapGesture {
            SocialLogin().attemptLoginFb()
        }
    }
    
    var appleButton : some View {
            Circle()
                .fill(Color.black)
                .frame(width: 50, height: 50)
                .overlay(
                    Image("icon-apple")
                        .resizable()
                        .aspectRatio(contentMode: ContentMode.fit)
                        .frame(width: 35, height: 35)
            ).shadow(radius: 5)
            .onTapGesture(perform: self.viewModel.showAppleLogin)
    }
}

