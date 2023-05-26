import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:for_practice_the_app/blocs/other/bloc_modules/followup/followup_bloc.dart';
import 'package:for_practice_the_app/models/api_requests/followup/telecaller_followup_history_request.dart';
import 'package:for_practice_the_app/models/api_responses/company_details/company_details_response.dart';
import 'package:for_practice_the_app/models/api_responses/followup/telecaller_followup_history_response.dart';
import 'package:for_practice_the_app/models/api_responses/login/login_user_details_api_response.dart';
import 'package:for_practice_the_app/ui/res/color_resources.dart';
import 'package:for_practice_the_app/ui/res/dimen_resources.dart';
import 'package:for_practice_the_app/ui/res/image_resources.dart';
import 'package:for_practice_the_app/ui/screens/base/base_screen.dart';
import 'package:for_practice_the_app/utils/date_time_extensions.dart';
import 'package:for_practice_the_app/utils/shared_pref_helper.dart';

class TeleCallerFollowupHistoryScreenArguments {
  String InqNo, CustomerID;
  TeleCallerFollowupHistoryScreenArguments(this.InqNo, this.CustomerID);
}

class TeleCallerFollowupHistoryScreen extends BaseStatefulWidget {
  static const routeName = '/TeleCallerFollowupHistoryScreen';
  final TeleCallerFollowupHistoryScreenArguments arguments;

  TeleCallerFollowupHistoryScreen(this.arguments);
  @override
  _TeleCallerFollowupHistoryScreenState createState() =>
      _TeleCallerFollowupHistoryScreenState();
}

class _TeleCallerFollowupHistoryScreenState
    extends BaseState<TeleCallerFollowupHistoryScreen>
    with BasicScreen, WidgetsBindingObserver {
  FollowupBloc _FollowupBloc;
  TeleCallerFollowupHestoryResponse _searchCustomerListResponse;
  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;
  int CompanyID = 0;
  String LoginUserID = "";
  String InqNo;
  String CustomerID;

  double sizeboxsize = 12;
  double _fontSize_Label = 9;
  double _fontSize_Title = 11;
  int label_color = 0xFF504F4F; //0x66666666;
  int title_color = 0xFF000000;

  @override
  void initState() {
    super.initState();
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;

    screenStatusBarColor = colorPrimary;
    _FollowupBloc = FollowupBloc(baseBloc);
    InqNo = widget.arguments.InqNo;
    CustomerID = widget.arguments.CustomerID;

    _FollowupBloc
      ..add(TeleCallerFollowupHistoryRequestEvent(
          TeleCallerFollowupHistoryRequest(
              ExtpkID: InqNo,
              LoginUserID: LoginUserID.toString(),
              CompanyId: CompanyID.toString())));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _FollowupBloc,
      child: BlocConsumer<FollowupBloc, FollowupStates>(
        builder: (BuildContext context, FollowupStates state) {
          if (state is TeleCallerFollowupHestoryResponseState) {
            //_onSearchInquiryListCallSuccess(state.followupHistoryListResponse);
            _onTeleCallerFollowupHistoryResponse(state.response);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is TeleCallerFollowupHestoryResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, FollowupStates state) {},
        listenWhen: (oldState, currentState) {
          return false;
        },
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return Column(
      children: [
        NewGradientAppBar(
          title: Text('TeleCaller History'),
          gradient: LinearGradient(colors: [
            Color(0xff108dcf),
            Color(0xff0066b3),
            Color(0xff62bb47),
          ]),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(
              left: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN2,
              right: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN2,
              top: 25,
            ),
            child: Column(
              children: [Expanded(child: _buildInquiryList())],
            ),
          ),
        ),
      ],
    );
  }

  ///builds header and title view

  ///builds inquiry list
  Widget _buildInquiryList() {
    if (_searchCustomerListResponse != null) {
      return ListView.builder(
        itemBuilder: (context, index) {
          return _buildSearchInquiryListItem(index);
        },
        shrinkWrap: true,
        itemCount: _searchCustomerListResponse.details.length,
      );
    } else {
      return Container(
        alignment: Alignment.center,
        child: Lottie.asset(NO_DATA_ANIMATED
            /*height: 200,
              width: 200*/
            ),
      );
    }
  }

  ///builds row item view of inquiry list
  Widget _buildSearchInquiryListItem(int index) {
    TeleCallerFollowupHestoryResponseDetails model =
        _searchCustomerListResponse.details[index];

    return Container(
      margin: EdgeInsets.all(5),
      child: InkWell(
        onTap: () {},
        child: Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: LinearGradient(
              colors: [
                Color(0xffffff8d),
                Color(0xffffff8d),
                Color(0xffb9f6ca),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Customer Name",
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Color(label_color),
                              fontSize: _fontSize_Label,
                              letterSpacing: .3)),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                          model.customerName == "" ? "N/A" : model.customerName,
                          style: TextStyle(
                              color: colorPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: _fontSize_Title,
                              letterSpacing: .3))
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: DEFAULT_HEIGHT_BETWEEN_WIDGET,
            ),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                child: _buildTitleWithValueView(
                    "Followup Date",
                    model.followupDate.getFormattedDate(
                            fromFormat: "yyyy-MM-ddTHH:mm:ss",
                            toFormat: "dd-MM-yyyy") ??
                        "-"),
              ),
              Expanded(
                child: _buildTitleWithValueView(
                    "Next Followup Date",
                    model.nextFollowupDate.getFormattedDate(
                            fromFormat: "yyyy-MM-ddTHH:mm:ss",
                            toFormat: "dd-MM-yyyy") ??
                        "-"),
              ),
            ]),
            SizedBox(
              height: DEFAULT_HEIGHT_BETWEEN_WIDGET,
            ),
            Row(children: [
              Expanded(
                child: _buildTitleWithValueView(
                    "Followup Type", model.inquiryStatus ?? "-"),
              ),
              Expanded(
                child: _buildTitleWithValueView(
                    "Lead #",
                    model.inquiryNo == "" || model.inquiryNo == null
                        ? '-'
                        : model.inquiryNo),
              ),
            ]),
            SizedBox(
              height: DEFAULT_HEIGHT_BETWEEN_WIDGET,
            ),
            _buildTitleWithValueView(
                "Notes",
                /*model.referenceName ?? "-" */
                model.meetingNotes == "" || model.meetingNotes == null
                    ? '-'
                    : model.meetingNotes),
            SizedBox(
              height: DEFAULT_HEIGHT_BETWEEN_WIDGET,
            ),
            /* Row(children: [
                  Expanded(
                   // child: _buildTitleWithValueView("No Followup", model.noFollowup.toString()),
                    child: _buildTitleWithValueView("No Followup", model.noFollowup.toString() == "false" ? 'no' : "yes"),
                  ),
                  Expanded(
                    child: _buildTitleWithValueView(
                        "Closer Reason", */ /*model.noFollClosureName ?? "-" */ /*
                        model.noFollClosureName == "--Not Available--" ||
                            model.noFollClosureName == null ? '-' : model
                            .noFollClosureName),
                  ),
                ]), */
            _buildTitleWithValueView(
                "FollowUp Initiated By :",
                /*model.referenceName ?? "-" */
                model.employeeName == "" || model.employeeName == null
                    ? '-'
                    : model.employeeName),
            SizedBox(
              height: DEFAULT_HEIGHT_BETWEEN_WIDGET,
            ),
          ]),
        ),
      ),
    );
  }

  ///calls search list api

  Widget _buildTitleWithValueView(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(
                fontSize: _fontSize_Label,
                color: Color(0xFF504F4F),
                /*fontWeight: FontWeight.bold,*/ fontStyle: FontStyle
                    .italic) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),
            ),
        SizedBox(
          height: 3,
        ),
        Text(value,
            style: TextStyle(
                fontSize: _fontSize_Title,
                color:
                    colorPrimary) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),
            )
      ],
    );
  }

  void _onTeleCallerFollowupHistoryResponse(
      TeleCallerFollowupHestoryResponse response) {
    _searchCustomerListResponse = response;
  }
}
