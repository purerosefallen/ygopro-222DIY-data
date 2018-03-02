--幻夏白雪 白莲
function c22260007.initial_effect(c)
	--special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_HAND)
	e0:SetCountLimit(1,222600071)
	e0:SetCondition(c22260007.sprcon)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22260007,2))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,222600072)
	e1:SetCost(c22260007.cost)
	e1:SetTarget(c22260007.target)
	e1:SetOperation(c22260007.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
function c22260007.IsNanayaShiki(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_NanayaShiki
end
function c22260007.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	return ct==0
end
function c22260007.costfilter(c)
	return c:IsAbleToGraveAsCost() and c22260007.IsNanayaShiki(c) and c:IsType(TYPE_MONSTER)
end
function c22260007.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22260007.costfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c22260007.costfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c22260007.tgfilter1(c)
	return c22260007.IsNanayaShiki(c) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c22260007.tgfilter2(c,e,tp)
	return c22260007.IsNanayaShiki(c) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22260007.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c22260007.tgfilter1,tp,LOCATION_GRAVE,0,1,nil)
	local b2=(Duel.IsExistingMatchingCard(c22260007.tgfilter2,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetMZoneCount(tp)>0)
	if chk==0 then return b1 or b2 end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(22260007,0)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(22260007,1)
		opval[off-1]=2
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==1 then
		e:SetCategory(CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	elseif sel==2 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	end
end
function c22260007.operation(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	local b1=Duel.IsExistingMatchingCard(c22260007.tgfilter1,tp,LOCATION_GRAVE,0,1,nil)
	local b2=(Duel.IsExistingMatchingCard(c22260007.tgfilter2,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetMZoneCount(tp)>0)
	if sel==1 and b1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=Duel.SelectMatchingCard(tp,c22260007.tgfilter1,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	elseif sel==2 and b2 then
		local g=Duel.SelectMatchingCard(tp,c22260007.tgfilter2,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end