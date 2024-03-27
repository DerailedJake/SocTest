class Contact < ApplicationRecord
  belongs_to :user
  belongs_to :acquaintance, class_name: 'User', foreign_key: :acquaintance_id
  validates :status, presence: true, inclusion: %w[stranger invited was_invited befriended blocked was_blocked]

  scope :unblocked, -> { where.not(status: 'was_blocked') }

  def self.available_status
    %w[stranger invited was_invited befriended blocked was_blocked]
  end

  def acquaintance_contact
    acquaintance.contacts.find_by(acquaintance_id: user.id)
  end

  def invitable?
    status == 'stranger'
  end

  def invite
    a_contact = acquaintance_contact || acquaintance.contacts.create(acquaintance: user, observed: nil)
    if a_contact.status == 'stranger' && status == 'stranger'
      a_contact.update!(status: 'was_invited')
      update(status: 'invited')
    else
      false
    end
  end

  def accept_invitation
    a_contact = acquaintance_contact
    if a_contact.status == 'invited' && status == 'was_invited'
      a_contact.update!(status: 'befriended')
      update(status: 'befriended')
    else
      false
    end
  end

  def cancel_invitation
    a_contact = acquaintance_contact
    if a_contact.status == 'was_invited' && status == 'invited'
      a_contact.remove_contact
      remove_contact
    else
      false
    end
  end

  def remove_friend
    a_contact = acquaintance_contact
    if a_contact.status == 'befriended' && status == 'befriended'
      a_contact.remove_contact
      remove_contact
    else
      false
    end
  end

  def block
    a_contact = acquaintance_contact || acquaintance.contacts.create(acquaintance: user, observed: nil)
    a_contact.update(status: 'was_blocked')
    update(status: 'blocked')
  end

  def unblock
    a_contact = acquaintance_contact
    a_contact.remove_contact
    remove_contact
  end

  def remove_contact
    if observed.nil?
      destroy
    else
      update!(status: 'stranger')
    end
  end
end
