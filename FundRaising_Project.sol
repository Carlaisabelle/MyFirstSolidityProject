// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

///@title RaccoltaFondi
///@author CarlaManavella

contract RaccoltaFondi {
    receive () external payable {} //With this function, the contract can receive funds from the outside

    enum Status {Raising, Ended} //The states available for this campaign
    Status public currentStatus;

    uint public goalCampaign = 1_000 ether; //Campaign goal
    uint totalRaised; //Variabile to collect the total of the donations received by the contract
    uint totalDonors; //Variable to collect the total number of the donors

    event FundReceived(address indexed to, uint amount, uint totalRaised, uint totalDonors); //Event that will then trigger the "emit" (to send a message to the blockchain when a donation arrives)

    struct Donation { //Structure that collects the contributions
        address contributor;
        uint amount;
    }

    constructor() {
        campaignManager = payable(0x71C7656EC7ab88b098defB751B7401B5f6d8976F); //Wallet address (THIS IS FAKE) of whom will acctually receive the donations collected by this contract
        startTime = block.timestamp;
    }

    Donation [] contribution;
    address payable public campaignManager; //This line says that the donations will be sent to the CampaignManager

    function contribute() public payable {
        require(currentStatus == Status.Raising); //This tells the function to check which if the current status of the campaign  is set on "Raising" (this way, if the status is set on "Ended" the function cannot work and the contract is not allowed to receive any more donation)
        contribution.push(
            Donation({
                contributor: msg.sender, //The address of the wallet who sent the "message" (that is, the Ethers sent to the contract)
                amount: msg.value //L'indirizzo di chi ha avviato la transazione per inviare una donazione
            })
        );
        totalRaised += msg.value; //what has just been donated is added automatically to totalRaised
        totalDonors = contribution.length; //The length of the array "contribution" is stored in the "totalDonors" variables: this will show the number of donations received by the contract 

        emit FundReceived(msg.sender, msg.value, totalRaised, totalDonors);
    }

    function checkFundRaisingCompletion() public view { //Function that checks if the "goalCampaign" has been reached or not
    if (totalRaised >= goalCampaign){
        "We made it!";
        } else {
        "Not there yet";
        }
    }

    function payOut () public payable {
        require(startTime + 183 days < block.timestamp); //To close the campaign 183 days (approximately 6 month) after it started
        currentStatus = Status.Ended; "Thank you for your donations!"; //The campaing status switches to "Ended" and a thankyou-message is shown
        campaignManager.transfer(address(this).balance); //The donations collected by the contract are transferred to the campaignManager wallet address
    }

    function removeContract() public {
        require(startTime + 4393 hours < block.timestamp); //Function that deletes permanently the contract 1 hour after the campaign completions; if any Ether is still on the contract, these will be transferred to the campaignManager wallet
        selfdestruct(payable(campaignManager));
        //I know that this keyword is deprecated; however, I could not find any substitution
    } //I decided to have the contract automatically auto-delete itself 1 hour after the campaign completion to avoid any possible error 
}