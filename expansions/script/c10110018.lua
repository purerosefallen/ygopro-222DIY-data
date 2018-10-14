--聚镒素 地风
function c10110018.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c10110018.ffilter1,c10110018.ffilter2,true)
	--reflect battle dam
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	c:RegisterEffect(e2)
	--todeck
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BATTLED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(c10110018.tdop)
	c:RegisterEffect(e3) 
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c10110018.discon)
	e4:SetOperation(c10110018.disop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_BE_BATTLE_TARGET)
	c:RegisterEffect(e5)   
end
function c10110018.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x9332) and c:IsControler(tp)
end
function c10110018.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=Duel.GetAttackTarget()
	if not c then return false end
	if c:IsControler(1-tp) then c=Duel.GetAttacker() end
	return c and c10110018.cfilter(c,tp)
end
function c10110018.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttackTarget()
	if tc:IsControler(tp) then tc=Duel.GetAttacker() end
	c:CreateRelation(tc,RESET_EVENT+0x1fe0000)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetCondition(c10110018.discon2)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetCondition(c10110018.discon2)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
	tc:RegisterEffect(e2)
end
function c10110018.discon2(e)
	return e:GetOwner():IsRelateToCard(e:GetHandler())
end
function c10110018.tdop(e,tp,eg,ep,ev,re,r,rp)
	local a,d=Duel.GetAttacker(),Duel.GetAttackTarget()
	if not d or a:GetControler()==d:GetControler() then return end
	if d:IsControler(tp) then a,d=d,a end
	if a:IsSetCard(0x9332) and d:IsRelateToBattle() and d:IsAbleToDeck() then
	   Duel.Hint(HINT_CARD,0,10110018)
	   Duel.SendtoDeck(d,nil,2,REASON_EFFECT)
	end
end
function c10110018.ffilter1(c,fc,sub,mg,sg)
	return c:IsFusionAttribute(ATTRIBUTE_EARTH) and (c:IsFusionSetCard(0x9332) or not sg or sg:IsExists(c10110018.ffilter3,1,nil,ATTRIBUTE_WIND))
end
function c10110018.ffilter2(c,fc,sub,mg,sg)
	return c:IsFusionAttribute(ATTRIBUTE_WIND) and (c:IsFusionSetCard(0x9332) or not sg or sg:IsExists(c10110018.ffilter3,1,nil,ATTRIBUTE_EARTH))
end
function c10110018.ffilter3(c,att)
	return c:IsFusionAttribute(att) and c:IsFusionSetCard(0x9332)
end