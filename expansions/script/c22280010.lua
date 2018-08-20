--微风之晶石
Duel.LoadScript("c22280001.lua")
c22280010.named_with_Spar=true
function c22280010.initial_effect(c)
	--gain
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_BE_MATERIAL)
	e0:SetCondition(c22280010.mtcon)
	e0:SetOperation(c22280010.mtop)
	c:RegisterEffect(e0)
	--SearchCard
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22280010,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_RELEASE)
	e1:SetCountLimit(1,22280010)
	e1:SetTarget(c22280010.tg)
	e1:SetOperation(c22280010.op)
	c:RegisterEffect(e1)
end
function c22280010.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_RITUAL
end
function c22280010.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=eg:GetFirst()
	while rc do
		if rc:GetFlagEffect(22280010)==0 and scorp.check_set_Spar(rc) then
			--chain attack
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(22280010,2))
			e1:SetCategory(CATEGORY_DESTROY)
			e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
			e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
			e1:SetCode(EVENT_BATTLE_DESTROYING)
			e1:SetCost(c22280010.atcost)
			e1:SetCondition(c22280010.atcon)
			e1:SetTarget(c22280010.attg)
			e1:SetOperation(c22280010.atop)
			rc:RegisterEffect(e1,true)
			if not rc:IsType(TYPE_EFFECT) then
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_ADD_TYPE)
				e3:SetValue(TYPE_EFFECT)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD)
				rc:RegisterEffect(e3,true)
			end
			rc:RegisterFlagEffect(22280010,RESET_EVENT+RESETS_STANDARD,0,1)
			rc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(22280010,0))
		end
		rc=eg:GetNext()
	end
end
function c22280010.atcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(22280012)==0 end
	c:RegisterFlagEffect(22280012,RESET_CHAIN,0,1)
end
function c22280010.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetAttacker()==c and c:IsRelateToBattle() and c:IsStatus(STATUS_OPPO_BATTLE) and c:IsChainAttackable(0,true)
end
function c22280010.tgfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c22280010.attg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c22280010.tgfilter(chkc) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(c22280010.tgfilter,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c22280010.tgfilter,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c22280010.atop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)>0 then
		Duel.ChainAttack()
	end
end
function c22280010.filter(c)
	return c:IsCode(22280006) and c:IsAbleToHand()
end
function c22280010.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c22280010.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstMatchingCard(c22280010.filter,tp,LOCATION_DECK,0,nil)
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end