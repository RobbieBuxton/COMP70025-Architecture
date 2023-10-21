!constant ORG "Royal Albert Hall"

workspace {
    model {
        phoneStaff = person "Ticket Sales Representative" "Internally accesses the booking system, booking tickets on behalf of the customer"
        officeStaff = person "Box Office Attendant" "Internally accesses the booking system, booking tickets on behalf of the customer"
        customer = person "Customer" "Browses performances and books tickets for events at the ${ORG}" {
            -> phoneStaff "Books tickets with" "over telephone"
            -> officeStaff "Books tickets with" "in person"
        }

        paymentsSystem = softwareSystem "Payment Gateway" "Processes card payments to confirm seat reservations"
        mailSystem = softwareSystem "Delivery System" "Arranges email and postal delivery of tickets to the customer"
        ticketScanningSystem = softwareSystem "Ticket Scanning System" "Validates issued tickets at the door"

        cms = softwareSystem "Content Management System (CMS)" "For staging, editing, and releasing event-related content"
        crm = softwareSystem "Customer Relationship Management (CRM)" "Stores and serves customer information"

        ticketSystem = softwareSystem "${ORG} Ticketing System" "Allows users (customers and staff) to browse current and future performances, book tickets and arrange their dispatch, as well as verify tickets at the door"{
            webApp = container "Web Application" "Delivers static content for internet browsing" "Java and Spring MVC"
            spa = container "Single Page Application" "Serves event-specific information and handles seat selection and booking" "JavaScript and Angular" "Web Browser"
            internalPortal = container "Internal Portal" "Provides browsing and booking functionalities for ${ORG} staff" "JavaScript and Angular"

            apiGateway = container "API Gateway" "Handles routing to microservices, calls to external systems and customer interactions" "RESTful API"

            ticketService = container "Ticketing Service" "Issues tickets for successful bookings and serves ticket delivery requests"
            ticketDb = container "Ticketing Database" "" "SQL DB" "Database"

            bookingService = container "Booking Service" "Handles seat reservations and bookings, providing synchronisation between clients"
            bookingDb = container "Booking Database" "" "SQL DB" "Database"

            userAccountService = container "User Account Service" "Validates user credentials and handles account creation and modification of user information"
            userAccountDb = container "User Account Database" "" "LDAP DB" "Database"

            // User interactions
            customer -> webapp "Accesses" "HTTPS"
            phoneStaff -> internalPortal "Accesses" "internally"
            officeStaff -> internalPortal "Accesses" "internally"

            // Webapp
            webApp -> spa "Delivers to the customer's web browser" "API"

            // Apigw interactions
            spa -> apiGateway "Makes calls to" "API"
            internalPortal -> apiGateway "Makes calls to" "API"
            apiGateway -> cms "Serves event content from" "API"
            apiGateway -> crm "Accesses customer relations info through" "API"
            apiGateway -> ticketService "Issues tickets through" "API"
            apiGateway -> bookingService "Processes reservations through" "API"
            apiGateway -> userAccountService "Handles user data through" "API"

            // Ticketing service
            ticketService -> ticketDb "Stores ticket info in" "TCP-IP"
            ticketService -> mailSystem "Sends ticket delivery info to" "API"
            ticketScanningSystem -> ticketService "Validates tickets through" "API"

            // Booking service
            bookingService -> bookingDb "Stores booking info in" "TCP-IP"
            bookingService -> paymentsSystem "Processes payments through" "API"

            // User account service
            userAccountService -> userAccountDb "Retrieves user info from" "LDAP"
        }
    }

    views {
        systemContext ticketSystem {
            include *
            autolayout tb
        }

        container ticketSystem {
            include *
            autolayout tb
        }

        styles {
            element "Database" {
                shape Cylinder
            }
            element "Web Browser" {
                shape WebBrowser
            }
        }

        theme default
    }
}
