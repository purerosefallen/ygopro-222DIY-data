--星之骑士拟身 烈焰
function c65090054.initial_effect(c)
	--fusion material
	c:SetSPSummonOnce(65090054)
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,65090001,aux.FilterBoolFunction(Card.IsRace,RACE_PYRO),1,true,true)
	--direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	e1:SetCondition(c65090054.dacon)
	c:RegisterEffect(e1)
	--change seq
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e2:SetTarget(c65090054.target)
	e2:SetOperation(c65090054.activate)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c65090054.filter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsControler(1-tp)
end
function c65090054.dacon(e)
	local tp=e:GetHandlerPlayer()
	local g=e:GetHandler():GetColumnGroup():Filter(c65090054.filter,nil,tp)
	return g:GetCount()==0 
end
function c65090054.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)>0 end
end
function c65090054.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	local nseq=math.log(s,2)
	if Duel.MoveSequence(c,nseq)~=0 then
		Duel.BreakEffect()
		local dg=c:GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
		if dg:GetCount()>0 then
			Duel.Destroy(dg,REASON_EFFECT)
		end
	end
end