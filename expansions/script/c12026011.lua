local m=12026011
local cm=_G["c"..m]
--来自白神的指引
function c12026011.initial_effect(c)
	--rec or dam
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12026011,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c12026011.target)
	e1:SetOperation(c12026011.operation)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,12026011)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c12026011.atktg)
	e2:SetOperation(c12026011.atkop)
	c:RegisterEffect(e2)
end
c12026011.lighting_with_Raphael=1
function c12026011.describe_with_Raphael(c)
	local m=_G["c"..c:GetCode()]
	return m and m.lighting_with_Raphael
end
function c12026011.tgfilter(c)
	return c:IsSetCard(0x4fbd) and c:IsType(TYPE_MONSTER)
end
function c12026011.sfilter(c,e,tp)
	return c:IsCode(12004020) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c12026011.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c12026011.tgfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c12026011.tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c12026011.atkop(e,tp,eg,ep,ev,re,r,rp)
	local sc=Duel.GetFirstMatchingCard(c12026011.sfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
		if sc and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(12026011,4)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,c12026011.sfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
		Duel.BreakEffect()
		local tc=Duel.GetFirstTarget()
		if Duel.SelectYesNo(tp,aux.Stringid(12026011,5)) then Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
		end 
end
function c12026011.costfilter(c)
	return ( c:IsSetCard(0x2fbd) or c:IsSetCard(0x1fbd) )and c:IsAbleToGrave()
end
function c12026011.ctfilter(c,e,tp)
	return (c:IsSetCard(0xfb0) or c:IsSetCard(0x2fbd)) and c:IsFaceup()
end
function c12026011.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP+TYPE_MONSTER)
end
function c12026011.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=( Duel.GetFlagEffect(tp,12026011+100)==0  and Duel.IsExistingMatchingCard(c12026011.costfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) )
	local ct=Duel.GetMatchingGroupCount(c12026011.ctfilter,tp,LOCATION_MZONE,0,nil)
	local b2=( ct>0 and Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,0x2fbd) and Duel.IsExistingMatchingCard(c12026011.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)  and Duel.GetFlagEffect(tp,12026011+200)==0 ) 
	if chk==0 then return b1 or b2 end
	local b3=( Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,12009100) and b1 and b2 ) 
	if b1 and b2 and b3 then op=Duel.SelectOption(tp,aux.Stringid(12026011,1),aux.Stringid(12026011,2),aux.Stringid(12026011,3))
	elseif b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(12026011,1),aux.Stringid(12026011,2))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(12026011,1))
	elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(12026011,2))+1
	else return end
	e:SetLabel(op)
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(12026011,op+1))
	if op==0 then
		e:SetCategory(CATEGORY_DRAW)
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(2)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	elseif op==1 then
		local g=Duel.GetMatchingGroup(c12026011.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		e:SetCategory(CATEGORY_DESTROY)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	else 
		e:SetCategory(CATEGORY_DRAW+CATEGORY_DESTROY)
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(2)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
		local g=Duel.GetMatchingGroup(c12026011.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	end
end
function c12026011.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 or e:GetLabel()==2 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c12026011.costfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	Duel.Draw(tp,2,REASON_EFFECT)
	end
	Duel.RegisterFlagEffect(tp,12026011+100,RESET_PHASE+PHASE_END,0,1)
	if e:GetLabel()==1 or e:GetLabel()==2 then
	local ct=Duel.GetMatchingGroupCount(c12026011.ctfilter,tp,LOCATION_MZONE,0,nil)
		local sg=Duel.GetMatchingGroup(c12026011.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		if ct>0 and sg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local dg=sg:Select(tp,1,ct,nil)
			Duel.HintSelection(dg)
			Duel.Destroy(dg,REASON_EFFECT)
		end
	Duel.RegisterFlagEffect(tp,12026011+200,RESET_PHASE+PHASE_END,0,1)
	end
end
