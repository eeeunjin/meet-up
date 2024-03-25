import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/model/policy_model.dart';
import 'package:meet_up/view_model/sign_up/sign_up_detail_view_model.dart';
import 'package:provider/provider.dart';

Widget PolicyAccept(BuildContext context) {
  final viewModel = Provider.of<SignUpDetailViewModel>(context);
  return Container(
    decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        color: Colors.white),
    height: 495.h,
    width: MediaQuery.of(context).size.width.w,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          height: 23.h,
        ),
        Center(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFCDCDCD),
              borderRadius: BorderRadius.all(
                Radius.circular(18.28.r),
              ),
            ),
            height: 3.35.h,
            width: 40.22.w,
          ),
        ),
        SizedBox(
          height: 26.55.h,
        ),
        Padding(
          padding: EdgeInsets.only(
            left: 32.h,
            right: 32.h,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 250.w,
                child: Text(
                  "밋업 사용을 위해\n필수 항목에 동의해주세요!",
                  style: TextStyle(
                    fontSize: 19.sp,
                    fontWeight: FontWeight.bold,
                    height: 0.0.h,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  viewModel.toggleAllAccpetPlicies();
                },
                icon: Icon(
                  Icons.check_box,
                  size: 26.82.h,
                  color: const Color(0xFFE6E6E6),
                ),
                selectedIcon: Icon(
                  Icons.check_box,
                  size: 26.82.h,
                  color: const Color(0xFF76E84E),
                ),
                isSelected: viewModel.acceptedPlicies[7],
              )
            ],
          ),
        ),
        SizedBox(
          height: 17.12.h,
        ),
        SizedBox(
          height: 228.63,
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(
              right: 36.w,
            ),
            itemCount: PolicyModel.policy.length,
            itemBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: 34.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        debugPrint("개별 약관 동의");
                        viewModel.toggleAcceptPolicies(index: index);
                      },
                      child: Row(
                        children: [
                          SizedBox(
                            width: 32.w,
                          ),
                          Icon(
                            Icons.check,
                            color: viewModel.acceptedPlicies[index]
                                ? const Color(0xFF76E84E)
                                : const Color(0xFF989898),
                            size: 20.w,
                          ),
                          const SizedBox(
                            width: 17.47,
                          ),
                          Text(
                            PolicyModel.policy[index + 1]!,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.normal,
                              color: viewModel.acceptedPlicies[index]
                                  ? Colors.black
                                  : const Color(0xFF989898),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        debugPrint("약관 내용 표시");
                      },
                      child: Icon(
                        Icons.chevron_right,
                        size: 20.h,
                        color: viewModel.acceptedPlicies[index]
                            ? Colors.black
                            : const Color(0xFF989898),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        SizedBox(
          height: 35.87.h,
        ),
        Center(
          child: GestureDetector(
            onTap: () {
              if (viewModel.isAcceptionValid) {
                // DB에 User 정보 전달하고 User data 넘기기
                debugPrint("동의하고 시작하기");
                context.pop();
              } else {
                debugPrint("필수 항목이 체크되지 않아 시작 불가");
              }
            },
            child: Container(
              width: 328.w,
              height: 56.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: viewModel.isAcceptionValid
                    ? const Color(0xFF76E84E)
                    : const Color(0xFFE6E6E6),
                borderRadius: BorderRadiusDirectional.circular(16.r),
              ),
              child: Text(
                "동의하고 시작하기",
                style: TextStyle(
                  color: viewModel.isAcceptionValid
                      ? Colors.white
                      : const Color(0xFF6B6B6B),
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
