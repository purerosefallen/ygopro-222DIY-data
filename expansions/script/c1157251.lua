--当代的念写记者
function c1157251.initial_effect(c)
--
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c1157251.mfilter,2)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c1157251.splimit)
	c:RegisterEffect(e1)
--
	if not c1157251.global_check then
		c1157251.global_check=true
		local e2=Effect.GlobalEffect()
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAINING)
		e2:SetOperation(c1157251.op2)
		Duel.RegisterEffect(e2,0)
	end
--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1157251,0))
	e3:SetCategory(CATEGORY_LEAVE_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c1157251.tg3)
	e3:SetOperation(c1157251.op3)
	c:RegisterEffect(e3)
--
end
--
function c1157251.mfilter(c)
	return c:IsLinkRace(RACE_WINDBEAST) and c:IsLinkAttribute(ATTRIBUTE_WIND)
end
--
function c1157251.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_LINK)~=0
end
--
function c1157251.op2(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	rc:RegisterFlagEffect(1157251,RESET_EVENT+0x00620000+RESET_PHASE+PHASE_END,0,1)
	rc:RegisterFlagEffect(1157252,RESET_EVENT+0x00620000+RESET_PHASE+PHASE_END,0,2)
end
--
function c1157251.tfilter3(c)
	return c:IsType(TYPE_SPELL) and c:IsSSetable() 
		and c:CheckActivateEffect(true,true,false)~=nil 
		and c:GetFlagEffect(1157251)~=c:GetFlagEffect(1157252)
end
function c1157251.tg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return tg and tg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
	end
	if chk==0 then return Duel.IsExistingTarget(c1157251.tfilter3,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) and Duel.GetLocationCount(1-tp,LOCATION_SZONE,tp)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c1157251.tfilter3,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	local tc=g:GetFirst()
	local te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(true,true,true)
	Duel.ClearTargetCard()
	tc:CreateEffectRelation(e)
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
--
function c1157251.op3(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	if not te:GetHandler():IsRelateToEffect(e) then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
	if Duel.GetLocationCount(1-tp,LOCATION_SZONE,tp)>0 then
		Duel.BreakEffect()
		Duel.SSet(tp,te:GetHandler(),1-tp)
	end
end
--
