--冰结之晶石
Duel.LoadScript("c22280001.lua")
c22280007.named_with_Spar=true
function c22280007.initial_effect(c)
	--gain
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_BE_MATERIAL)
	e0:SetCondition(c22280007.mtcon)
	e0:SetOperation(c22280007.mtop)
	c:RegisterEffect(e0)
	--SearchCard
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22280007,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_RELEASE)
	e1:SetCountLimit(1,22280007)
	e1:SetTarget(c22280007.tg)
	e1:SetOperation(c22280007.op)
	c:RegisterEffect(e1)
end
function c22280007.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_RITUAL
end
function c22280007.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=eg:GetFirst()
	while rc do
		if rc:GetFlagEffect(22280007)==0 and scorp.check_set_Spar(rc) then
			--Recover
			local e1=Effect.CreateEffect(c)
			e1:SetCategory(CATEGORY_RECOVER)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_F)
			e1:SetCode(EVENT_CHAINING)
			e1:SetRange(LOCATION_MZONE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetCost(c22280007.reccost)
			e1:SetCondition(c22280007.reccon)
			e1:SetTarget(c22280007.rectg)
			e1:SetOperation(c22280007.recop)
			rc:RegisterEffect(e1,true)
			if not rc:IsType(TYPE_EFFECT) then
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_ADD_TYPE)
				e3:SetValue(TYPE_EFFECT)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD)
				rc:RegisterEffect(e3,true)
			end
			rc:RegisterFlagEffect(22280007,RESET_EVENT+RESETS_STANDARD,0,1)
			rc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(22280007,0))
		end
		rc=eg:GetNext()
	end
end
function c22280007.reccost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(22280008)==0 end
	c:RegisterFlagEffect(22280008,RESET_CHAIN,0,1)
end
function c22280007.reccon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp
end
function c22280007.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,500)
end
function c22280007.recop(e,tp,eg,ep,ev,re,r,rp,chk)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function c22280007.filter(c)
	return c:IsCode(22280009) and c:IsAbleToHand()
end
function c22280007.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c22280007.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstMatchingCard(c22280007.filter,tp,LOCATION_DECK,0,nil)
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end