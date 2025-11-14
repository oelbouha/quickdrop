# QuickDrop — User Guide

This user guide explains how to use the QuickDrop mobile app from the perspective of the two primary user types: Senders and Couriers.

## App overview

QuickDrop connects people who need to ship packages (Senders) with travelers (Couriers) going along the same route.

Main features:
- Create and browse shipments and trips
- Secure in-app payments (Stripe)
- Real-time messaging and notifications
- Profile verification and ratings
- Shipment tracking and status updates

## Signing up and signing in

Options:
- Email/password
- Google sign-in
- Phone number verification (if configured)

If you have trouble signing in, check FAQ entry about authentication.

## For Senders (how to create a shipment)

1. From Home, tap Create Shipment.
2. Fill package details: title, weight, dimensions, description, value.
3. Choose pickup and delivery locations and desired delivery window.
4. Set a price or choose to accept offers from couriers.
5. Upload any images of the package.
6. Publish the listing.

Once the listing is live, you can:
- View interested couriers
- Accept an offer
- Chat with the courier
- Pay when the courier confirms (or use escrow behavior if configured)
- Track the shipment status until delivered

## For Couriers (how to create a trip)

1. Go to Create Trip.
2. Enter your route, date and available capacity.
3. Set prices or accept requests from senders.
4. Mark accepted shipments as Picked Up / In Transit / Delivered to update sender.

Couriers should keep profile and verification details up-to-date to earn trust and unlock more opportunities.

## Payments

- Payments are handled through Stripe.
- Senders pay via the app when a shipment is accepted.
- For testing, use Stripe test keys set in `.env` and test cards from Stripe docs.

## Messaging and notifications

- Use in-app chat to coordinate pickup and delivery with the other party.
- Enable push notifications to get real-time updates.

## Profile and verification

- Complete your profile (photo, name, ID if required).
- Verified Couriers get higher visibility.
- Ratings and reviews influence trust scores.

## Tracking status flow

Typical lifecycle:
- Draft -> Posted -> Accepted -> Picked Up -> In Transit -> Delivered -> Completed

Each status transition triggers notifications to both parties.

## Troubleshooting common flows

- If a courier fails to show up, open the shipment and use the `Report` or `Cancel` actions.
- If payment fails, try a different card or verify that your Stripe keys and `.env` are configured.
- If images fail to upload, check network connection and storage permissions.

## Safety and community guidelines

- Never transfer payment outside the app unless explicitly supported.
- Use in-app chat to keep communication recorded.
- Rate your counterpart after delivery to help the community.

## Contact support

For help, see `docs/help.md` in the repository for how to file a bug or get support.
