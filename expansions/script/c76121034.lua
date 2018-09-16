--刻印的黄金柜
function c76121034.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c76121034.rmtg)
	e1:SetOperation(c76121034.rmop)
	c:RegisterEffect(e1)
end
function c76121034.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c76121034.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_DECK,0,1,1,nil)
	local tg=g:GetFirst()
	if tg==nil then return end
	Duel.Remove(tg,POS_FACEDOWN,REASON_EFFECT)
	tg:RegisterFlagEffect(76121034,RESET_EVENT+0x1fe0000,0,1)
	if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetOperation(c76121034.disop)
	e1:SetLabelObject(tg)
	Duel.RegisterEffect(e1,tp)
end
function c76121034.disop(e,tp,eg,ep,ev,re,r,rp)
	local tg=e:GetLabelObject()
	local cod=tg:GetCode()
	local rc=re:GetHandler()
	if tg:GetFlagEffect(76121034)==0 or ep==tp or rc:GetCode()~=cod then return end
	if Duel.SelectYesNo(tp,aux.Stringid(76121034,2)) then
		local op=0
		local b=tg:IsAbleToHand()
		if b then op=Duel.SelectOption(tp,aux.Stringid(76121034,0),aux.Stringid(76121034,1))
		else
			Duel.SelectOption(tp,aux.Stringid(76121034,1)) op=1
		end
		if op==0 then
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tg)
		else
			Duel.SendtoGrave(tg,REASON_EFFECT+REASON_RETURN)
			if Duel.NegateEffect(ev) and rc:IsRelateToEffect(re) then
				Duel.Destroy(rc,REASON_EFFECT)
			end
		end
	end
end