--下位哨戒天狗
function c1157005.initial_effect(c)
--
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c1157005.mfilter,1)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c1157005.splimit)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SET_POSITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c1157005.tg2)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(POS_FACEUP_DEFENSE)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	c:RegisterEffect(e3)
--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(1157005,0))
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c1157005.con4)
	e4:SetTarget(c1157005.tg4)
	e4:SetOperation(c1157005.op4)
	c:RegisterEffect(e4)
--
end
--
function c1157005.mfilter(c)
	return c:IsLinkRace(RACE_BEASTWARRIOR) and not c:IsLinkType(TYPE_LINK)
end
--
function c1157005.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_LINK)~=0
end
--
function c1157005.tg2(e,c)
	local rc=e:GetHandler()
	local rg=rc:GetLinkedGroup()
	return rg:IsContains(c)
end
--
function c1157005.con4(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp
end
--
function c1157005.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
end
--
function c1157005.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SendtoDeck(c,nil,2,REASON_EFFECT)>0 then
		local e4_1=Effect.CreateEffect(c)
		e4_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4_1:SetCode(EVENT_PHASE+PHASE_END)
		e4_1:SetCountLimit(1)
		e4_1:SetCondition(c1157005.con4_1)
		e4_1:SetOperation(c1157005.op4_1)
		e4_1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e4_1,tp)
	end
end
--
function c1157005.cfilter4_1(c,e,tp)
	return c:IsCode(1156902) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c1157005.con4_1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c1157005.cfilter4_1,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.GetLocationCountFromEx(tp)>0
end
--
function c1157005.op4_1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c1157005.cfilter4_1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if sg:GetCount()<1 then return end
	local sc=sg:GetFirst()
	if Duel.SpecialSummon(sc,0,tp,tp,true,false,POS_FACEUP)>0 then
		local e4_1_1=Effect.CreateEffect(c)
		e4_1_1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e4_1_1:SetType(EFFECT_TYPE_SINGLE)
		e4_1_1:SetCode(EFFECT_IMMUNE_EFFECT)
		e4_1_1:SetRange(LOCATION_MZONE)
		e4_1_1:SetValue(c1157005.efilter4_1_1)
		e4_1_1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN)
		sc:RegisterEffect(e4_1_1,true)
	end
end
--
function c1157005.efilter4_1_1(e,te)
	local c=e:GetHandler()
	local ec=te:GetHandler()
	if (te:IsHasType(EFFECT_TYPE_ACTIONS) and te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and c:IsRelateToEffect(te)) or ec:IsHasCardTarget(c) then return false end
	return te:GetHandlerPlayer()~=e:GetHandlerPlayer()
end
--