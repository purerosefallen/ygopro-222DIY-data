--STS遗物·
function c107898209.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c107898209.target)
	e1:SetOperation(c107898209.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c107898209.eqlimit)
	c:RegisterEffect(e2)
	--draw when spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(107898209,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c107898209.drcon)
	e3:SetTarget(c107898209.drtg)
	e3:SetOperation(c107898209.drop1)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_CUSTOM+107898209)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c107898209.drcon)
	e4:SetTarget(c107898209.drtg)
	e4:SetOperation(c107898209.drop2)
	c:RegisterEffect(e4)
	if not c107898209.global_check then
		c107898209.global_check=true
		--costum when effect
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetRange(LOCATION_SZONE)
		ge1:SetOperation(aux.chainreg)
		Duel.RegisterEffect(ge1,0)
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_DELAY)
		ge1:SetCode(EVENT_CHAIN_SOLVING)
		ge1:SetOperation(c107898209.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c107898209.checkop(e,tp,eg,ep,ev,re,r,rp)
	local c=re:GetHandler()
	local sc=e:GetHandler()
	if not re:IsActiveType(TYPE_MONSTER) 
	or (not c:IsSetCard(0x575b) and not c:IsSetCard(0x575c)) 
	or not c:IsPreviousLocation(LOCATION_HAND) or e:GetHandler():GetFlagEffect(1)<=0 then return end
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+107898209,e,0,dp,0,0)
end
function c107898209.eqfilter1(c)
	return c:IsFaceup() and (c:IsCode(107898101) or c:IsCode(107898102) or c:IsCode(107898103))
end
function c107898209.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c107898209.eqfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c107898209.eqfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c107898209.eqfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c107898209.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() and c:CheckUniqueOnField(tp) then
		Duel.Equip(tp,c,tc)
	end
end
function c107898209.eqlimit(e,c)
	return c:IsCode(107898101) or c:IsCode(107898102) or c:IsCode(107898103)
end
function c107898209.efilter(e,te)
	return not te:GetOwner():IsSetCard(0x575)
end
function c107898209.drcon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and Duel.GetTurnPlayer()==tp and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0
end
function c107898209.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c107898209.dfilter(c)
	return c:IsSetCard(0x575a) and c:IsPreviousLocation(LOCATION_HAND)
end
function c107898209.drop1(e,tp,eg,ep,ev,re,r,rp)
	local sc=e:GetHandler()
	if eg:IsExists(c107898209.dfilter,1,nil) then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Draw(p,d,REASON_EFFECT)
	end
end
function c107898209.drop2(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end