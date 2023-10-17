workspace {

    model {
        user = person "User"
        ticketSystem = softwareSystem "Royal Albert Hall Ticket System" {
            webApp = container "Web Application" {
                user -> this "Uses"
            }
						eventProgram = container "Program of Events" {
							webApp -> this "Delivers to the customer's web browser"
						}
						ticketBooker = container "Ticket Booker" {
							eventProgram -> this "Deliver to browser when user clicks on an event"
						}
						seatSelector = container "Seat Selector" {
							ticketBooker -> this "Deliver to browser if user wants to choose seats"
						}
            database = container "Database" {
                this -> eventProgram "list of events, small description, number of free tickets"
								this -> ticketBooker "full event details"
								this -> seatSelector "free and booked seats"
								ticketBooker -> this "book held seats"
								seatSelector -> this "hold seats"
            }
        }
				paymentsSystem = softwareSystem "Payments System" 
				emailSystem = softwareSystem "Email System" 
				mailSystem = softwareSystem "Mail System"

				ticketBooker -> paymentsSystem "Purchase ticket"
				ticketBooker -> emailSystem "Email tickets to customer"
				ticketBooker -> mailSystem "Mail tickets to customer"
    }

    views {
        systemContext ticketSystem {
            include *
            autolayout lr
        }

        container ticketSystem {
            include *
            autolayout lr
        }
				
        theme default
    }

}