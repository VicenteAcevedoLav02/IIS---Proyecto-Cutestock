class OrderMailer < ApplicationMailer
  
  # se manda un mail cada vez que order.state se actualiza
  def state_changed(order, previous_state, user_email)
    @order = order
    @previous_state = previous_state

    mail(
      to: user_email, 
      subject: "La orden #{order.name} ha cambiado de estado."
    )
  end
end