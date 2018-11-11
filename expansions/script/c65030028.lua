--堕天的二重阴影
function c65030028.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_TOGRAVE+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1,65030028)
	e1:SetTarget(c65030028.tg)
	e1:SetOperation(c65030028.op)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(c65030028.indval)
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e12:SetRange(LOCATION_SZONE)
	e12:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e12:SetTarget(c65030028.eftg)
	e12:SetLabelObject(e2)
	c:RegisterEffect(e12)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetValue(c65030028.efilter)
	local e13=e12:Clone()
	e13:SetLabelObject(e3)
	c:RegisterEffect(e13)
	--attack all
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_ATTACK_ALL)
	e4:SetValue(1)
	local e14=e12:Clone()
	e14:SetLabelObject(e4)
	c:RegisterEffect(e14)
	--disable
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_ATTACK_ANNOUNCE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c65030028.discon)
	e5:SetOperation(c65030028.disop)
	local e15=e12:Clone()
	e15:SetLabelObject(e5)
	c:RegisterEffect(e15)
	local e6=e5:Clone()
	e6:SetCode(EVENT_BE_BATTLE_TARGET)
	local e16=e12:Clone()
	e16:SetLabelObject(e6)
	c:RegisterEffect(e16)
	--effect!
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_ADD_TYPE)
	e7:SetRange(LOCATION_FZONE)
	e7:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e7:SetValue(TYPE_EFFECT)
	e7:SetTarget(c65030028.eftg)
	c:RegisterEffect(e7)
end
function c65030028.indval(e,c)
	return c:IsType(TYPE_EFFECT)
end
function c65030028.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwner()~=e:GetOwner()
end
function c65030028.eftg(e,c)
	return c:GetOriginalType()~=TYPE_EFFECT and c:IsType(TYPE_XYZ)
end
function c65030028.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=Duel.GetAttackTarget()
	return c 
end
function c65030028.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttackTarget()
	if tc:IsControler(tp) then tc=Duel.GetAttacker() end
	c:CreateRelation(tc,RESET_EVENT+RESETS_STANDARD)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetCondition(c65030028.discon2)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetCondition(c65030028.discon2)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e2)
end
function c65030028.discon2(e)
	return e:GetOwner():IsRelateToCard(e:GetHandler())
end

function c65030028.fil(c)
	return c:IsSetCard(0xcda1) and c:IsAbleToHand()
end
function c65030028.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_DECK,0,1,nil,TYPE_MONSTER) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c65030028.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_DECK,0,1,1,nil,TYPE_MONSTER)
	if g:GetCount() then
		if Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
			Duel.BreakEffect()
			local tc=Duel.GetOperatedGroup():GetFirst()
			if tc:IsType(TYPE_NORMAL) and Duel.IsExistingMatchingCard(c65030028.fil,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(65030028,0)) then
				local sg=Duel.SelectMatchingCard(tp,c65030028.fil,tp,LOCATION_DECK,0,1,1,nil)
				Duel.SendtoHand(sg,tp,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
			elseif not tc:IsType(TYPE_NORMAL) then
				Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
			end
		end
	end
end