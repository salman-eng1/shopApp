import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layouts/shop_app/shop_layout.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'package:shop_app/shared/styles/colors.dart';

import 'cubit/cubit.dart';
import 'cubit/states.dart';

class ShopRegisterScreen extends StatelessWidget {
  var formkey = GlobalKey<FormState>();

  var emailController=TextEditingController();
  var passwordController=TextEditingController();
  var nameController=TextEditingController();
  var phoneController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>ShopRegisterCubit(),
      child: BlocConsumer <ShopRegisterCubit,ShopRegisterStates>(
        listener: (context, state) {
          if (state is ShopRegisterSuccessState){
            if(state.loginModel.status==true){
              print(state.loginModel.message);
              print(state.loginModel.data!.token);
              CacheHelper.saveData(key: 'token', value: state.loginModel.data!.token);
              navigateTo(context, ShopLayout());
              showToast(message: "${state.loginModel.message}", state: ToastStates.SUCCESS);
              CacheHelper.saveData(key: 'token', value: state.loginModel.data!.token)!.then((value){
                navigateAndFinish(context, ShopLayout());
              });
            }else{
              print(state.loginModel.message);
              showToast(message:"${state.loginModel.message}", state: ToastStates.WARNING);
            }
          }

        },

        builder: (context,state) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formkey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('REGISTER',
                          style: Theme.of(context).textTheme.headline3!.copyWith(color: defaultColor),
                        ),
                        Text('Register now to brows our hot offers',
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.grey),
                        ),
                        defaultFormField(
                          validator: (String? value){
                            if(value!.isEmpty){
                              return 'please enter name';
                            }
                          },
                          controller: nameController,
                          type: TextInputType.name,
                          label: 'User Name',
                          prefix: Icons.person,
                          isPassword: false,
                        ),
                        SizedBox(height: 15.0,),
                        defaultFormField(
                          validator: (String? value){
                            if(value!.isEmpty){
                              return 'please enter email';
                            }
                          },
                          controller: emailController,
                          type: TextInputType.emailAddress,
                          label: 'Email',
                          prefix: Icons.email_outlined,
                          isPassword: false,
                        ),

                        SizedBox(height: 15.0,),

                        defaultFormField(
                          validator: (String? value){
                            if(value!.isEmpty){
                              return 'please enter password';
                            }
                          },
                          controller: passwordController,
                          type: TextInputType.visiblePassword,
                          suffix: ShopRegisterCubit.get(context).suffix,
                          suffixPressed: (){
                            ShopRegisterCubit.get(context).changePasswordVisibility();
                          },
                          isPassword:ShopRegisterCubit.get(context).isPassword,
                          label: 'Password',
                          prefix: Icons.lock_clock_outlined,
                          onSubmit: (value){}
                        ),
                        SizedBox(height: 30.0),
                        defaultFormField(
                          validator: (String? value){
                            if(value!.isEmpty){
                              return 'please enter phone number';
                            }
                          },
                          controller: phoneController,
                          type: TextInputType.number,
                          label: 'phone number',
                          prefix: Icons.phone,
                          isPassword: false,
                        ),
                        SizedBox(height: 30.0),

                        ConditionalBuilder(
                          builder: (BuildContext context)  =>
                              defaultButton(
                                function: (){
                                  if(formkey.currentState!.validate()) {
                                    ShopRegisterCubit.get(context).userRegister(
                                      name : nameController.text,
                                        email: emailController.text,
                                        password: passwordController.text,
                                    phone: phoneController.text);
                                  }},
                                text: 'register',
                                background: defaultColor,
                              ),
                          condition: state is! ShopRegisterLoadingState,
                          fallback: (context) => Center(child: CircularProgressIndicator()) ,

                        ),



                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
