--Answer·日高爱
function c81010044.initial_effect(c)
	c:SetSPSummonOnce(81010044)
	--xyz summon
	aux.AddXyzProcedure(c,nil,11,2,c81010044.ovfilter,aux.Stringid(81010044,0))
	c:EnableReviveLimit()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCategory(CATEGORY_DECKDES)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c81010044.discon)
	e1:SetTarget(c81010044.distg)
	e1:SetOperation(c81010044.disop)
	c:RegisterEffect(e1)
	--cannot attack announce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_ATTACK)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c81010044.antarget)
	c:RegisterEffect(e3)
	--life lost
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCondition(c81010044.descon)
	e4:SetOperation(c81010044.desop)
	c:RegisterEffect(e4)
end
function c81010044.antarget(e,c)
	return c~=e:GetHandler()
end
function c81010044.ovfilter(c)
	return c:IsFaceup() and c:IsLinkAbove(5) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_LINK)
end
function c81010044.discon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c81010044.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,15)
end
function c81010044.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(tp,15,REASON_EFFECT)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local ct=Duel.GetOperatedGroup():FilterCount(Card.IsType,nil,TYPE_MONSTER)
		if ct>0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(ct*200)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			c:RegisterEffect(e1)
		end
	end
end
function c81010044.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP)
end
function c81010044.desop(e,tp,eg,ep,ev,re,r,rp)
	local lp=Duel.GetLP(tp)
	Duel.SetLP(tp,lp-5000)
end
