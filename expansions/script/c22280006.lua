--砂岩之晶石
Duel.LoadScript("c22280001.lua")
c22280006.named_with_Spar=true
function c22280006.initial_effect(c)
	--gain
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_BE_MATERIAL)
	e0:SetCondition(c22280006.mtcon)
	e0:SetOperation(c22280006.mtop)
	c:RegisterEffect(e0)
	--SearchCard
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22280006,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_RELEASE)
	e1:SetCountLimit(1,22280006)
	e1:SetTarget(c22280006.tg)
	e1:SetOperation(c22280006.op)
	c:RegisterEffect(e1)
end
function c22280006.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_RITUAL
end
function c22280006.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=eg:GetFirst()
	while rc do
		if rc:GetFlagEffect(22280006)==0 and scorp.check_set_Spar(rc) then
			--Def
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_UPDATE_DEFENSE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetTargetRange(LOCATION_MZONE,0)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetTarget(aux.TargetBoolFunction(Card.IsFaceup))
			e1:SetValue(1000)
			rc:RegisterEffect(e1,true)
			--indes
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e2:SetRange(LOCATION_MZONE)
			e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
			e2:SetCountLimit(1)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			e2:SetValue(c22280006.indct)
			rc:RegisterEffect(e2,true)
			if not rc:IsType(TYPE_EFFECT) then
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_ADD_TYPE)
				e3:SetValue(TYPE_EFFECT)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD)
				rc:RegisterEffect(e3,true)
			end
			rc:RegisterFlagEffect(22280006,RESET_EVENT+RESETS_STANDARD,0,1)
			rc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(22280006,0))
		end
		rc=eg:GetNext()
	end
end
function c22280006.indct(e,re,r,rp)
	return bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end
function c22280006.filter(c)
	return c:IsCode(22280007) and c:IsAbleToHand()
end
function c22280006.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c22280006.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstMatchingCard(c22280006.filter,tp,LOCATION_DECK,0,nil)
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end