--STSA·勒脖
function c107898314.initial_effect(c)
	c:EnableReviveLimit()
	--special summon rule
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_HAND)
	e0:SetCondition(c107898314.spcon)
	e0:SetOperation(c107898314.spop)
	c:RegisterEffect(e0)
	--atk down/damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(107898314,2))
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c107898314.adtg)
	e1:SetOperation(c107898314.adop)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(107898314,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetTarget(c107898314.tgtg)
	e2:SetOperation(c107898314.tgop)
	c:RegisterEffect(e2)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(107898314,0))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1)
	e3:SetTarget(c107898314.atktg)
	e3:SetOperation(c107898314.atkop)
	c:RegisterEffect(e3)
end
function c107898314.cfilter(c)
	return c:IsFaceup() and c:IsCode(107898102)
end
function c107898314.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local lv=c:GetLevel()
	local clv=math.floor(c:GetLevel()/2)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c107898314.cfilter,tp,LOCATION_ONFIELD,0,1,nil) and (lv==1 or Duel.IsCanRemoveCounter(tp,1,0,0x1,clv,REASON_COST))
end
function c107898314.spop(e,tp,eg,ep,ev,re,r,rp,c)
	if c:GetLevel()>1 then
		Duel.RemoveCounter(tp,1,0,0x1,math.floor(c:GetLevel()/2),REASON_COST)
	end
end
function c107898314.adtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	if Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) then
		local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
		e:SetLabel(0)
	else
		Duel.SetTargetPlayer(1-tp)
		e:SetLabel(1)
	end
end
function c107898314.dfilter(c)
	return c:IsSetCard(0x575a) and c:IsPreviousLocation(LOCATION_HAND)
end
function c107898314.dmgop1(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c107898314.dfilter,1,nil) then
		Duel.Damage(tp,300,REASON_EFFECT)
	end
end
function c107898314.dmgop2(e,tp,eg,ep,ev,re,r,rp)
	local c=re:GetHandler()
	if re:IsActiveType(TYPE_MONSTER) and (c:IsSetCard(0x575b) or c:IsSetCard(0x575c)) and c:IsPreviousLocation(LOCATION_HAND) and e:GetHandler():GetFlagEffect(1)>0 then
		Duel.Damage(tp,300,REASON_EFFECT)
	end
end
function c107898314.adop1(e,tp,eg,ep,ev,re,r,rp)
	local sc=e:GetHandler()
	if eg:IsExists(c107898314.dfilter,1,nil) then
	   local e1=Effect.CreateEffect(sc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		e1:SetValue(-300)
		sc:RegisterEffect(e1)
		if sc:IsAttack(0) then
			Duel.Destroy(sc,REASON_EFFECT)
		end
	end
end
function c107898314.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2 and Duel.GetTurnPlayer()==tp
end
function c107898314.adop2(e,tp,eg,ep,ev,re,r,rp)
	local c=re:GetHandler()
	local sc=e:GetHandler()
	if re:IsActiveType(TYPE_MONSTER) and (c:IsSetCard(0x575b) or c:IsSetCard(0x575c)) and c:IsPreviousLocation(LOCATION_HAND) and e:GetHandler():GetFlagEffect(1)>0 then
		local e1=Effect.CreateEffect(sc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		e1:SetValue(-300)
		sc:RegisterEffect(e1)
		if sc:IsAttack(0) then
			Duel.Destroy(sc,REASON_EFFECT)
		end
	end
end
function c107898314.adop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local yn=e:GetLabel()
	if yn==0 then
		local tc=Duel.GetFirstTarget()
		if not tc or not tc:IsRelateToEffect(e) then return end
		--atk down
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetRange(LOCATION_MZONE)
		e1:SetOperation(c107898314.adop1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		--atk down when effect
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EVENT_CHAINING)
		e2:SetRange(LOCATION_MZONE)
		e2:SetOperation(aux.chainreg)
		tc:RegisterEffect(e2)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetProperty(EFFECT_FLAG_DELAY)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCondition(c107898314.condition)
		e2:SetOperation(c107898314.adop2)
		e2:SetReset(RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		return
	end
	if yn==1 then
		local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,0)
		--dmg
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetOperation(c107898314.dmgop1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,p)
		--dmg when effect
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EVENT_CHAINING)
		e2:SetOperation(aux.chainreg)
		Duel.RegisterEffect(e2,p)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
		e2:SetOperation(c107898314.dmgop2)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,p)
	end
end
function c107898314.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c107898314.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c107898314.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c107898314.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c107898314.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not (c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e)) then return end
	local atk=tc:GetAttack()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	e1:SetValue(atk)
	c:RegisterEffect(e1)
end
function c107898314.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
end
function c107898314.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.SendtoGrave(c,REASON_EFFECT)
	end
end