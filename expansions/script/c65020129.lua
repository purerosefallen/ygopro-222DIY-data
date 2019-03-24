--响色绘描·迷幻
function c65020129.initial_effect(c)
	 --fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode3(c,65020113,65020117,65020119,true,true)
	--change seq
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,65020129)
	e1:SetCost(c65020129.cost)
	e1:SetTarget(c65020129.tg)
	e1:SetOperation(c65020129.op)
	c:RegisterEffect(e1)
	--double
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c65020129.damcon)
	e4:SetOperation(c65020129.damop)
	c:RegisterEffect(e4)
	--avoid damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xcda4))
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c65020129.damcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local b=Duel.GetAttackTarget()
	return ep~=tp and ((b~=nil and b:IsSetCard(0xcda4)) or a:IsSetCard(0xcda4))
end
function c65020129.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev*2)
end
function c65020129.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c65020129.tgfil(c,tp)
	return c:IsSetCard(0xcda4) and c:IsSSetable() and (Duel.GetLocationCount(tp,LOCATION_SZONE)>0 or c:IsType(TYPE_FIELD))
end
function c65020129.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)>0 and Duel.IsExistingMatchingCard(c65020129.tgfil,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c65020129.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	local nseq=math.log(s,2)
	if Duel.MoveSequence(c,nseq)~=0 and Duel.IsExistingMatchingCard(c65020129.tgfil,tp,LOCATION_DECK,0,1,nil,tp) then
		local g=Duel.SelectMatchingCard(tp,c65020129.tgfil,tp,LOCATION_DECK,0,1,1,nil,tp)
		local tc=g:GetFirst()
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
	end
end