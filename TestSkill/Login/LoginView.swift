import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel
    init(){
        viewModel = LoginViewModel()
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
                Spacer()
            }.padding()
            }
        .modal(isShowing: self.$viewModel.showRegisterPage, content: {
            LazyView(RegisterPage(closeFlag: self.$viewModel.showRegisterPage))
        })
            .modal(isShowing: self.$viewModel.showForgetPassword, content: {
            LazyView(ForgetPasswordView(closeFlag: self.$viewModel.showForgetPassword))
        })
        
    }
    
    var loginButton : some View{
        Button(action: {
            self.viewModel.normalLogin()
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
        .keyboardResponsive()
        .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
    }
    
    func upperArea() -> some View{
        VStack{
            PageView(viewModel.sampleDataForPageView)
                .aspectRatio(contentMode: ContentMode.fit)

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
//        SignInWithApple() 
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

