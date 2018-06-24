--脱兔『Fluster Escape』
function c11200069.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e1:SetCondition(c11200069.con1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,11200069+EFFECT_COUNT_CODE_OATH)
	e3:SetTarget(c11200069.tg3)
	e3:SetOperation(c11200069.op3)
	c:RegisterEffect(e3)
--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(11200020,1))
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c11200069.con4)
	e4:SetTarget(c11200069.tg4)
	e4:SetOperation(c11200069.op4)
	c:RegisterEffect(e4)
--
end
--
function c11200069.cfilter1(c)
	return not (c:IsRace(RACE_BEAST) and c:IsAttribute(ATTRIBUTE_LIGHT))
end
function c11200069.con1(e)
	return not Duel.IsExistingMatchingCard(c11200069.cfilter1,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
--
function c11200069.tfilter3(c,e,tp)
	return (c:IsSetCard(0x133) or c:IsSetCard(0x132)) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11200069.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c11200069.tfilter3,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK)
end
--
function c11200069.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c11200069.tfilter3,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if sg:GetCount()<1 then return end
	local sc=sg:GetFirst()
	Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP)
	local e3_1=Effect.CreateEffect(c)
	e3_1:SetType(EFFECT_TYPE_SINGLE)
	e3_1:SetCode(EFFECT_DISABLE)
	e3_1:SetReset(RESET_EVENT+0x1fe0000)
	sc:RegisterEffect(e3_1,true)
	local e3_2=Effect.CreateEffect(c)
	e3_2:SetType(EFFECT_TYPE_SINGLE)
	e3_2:SetCode(EFFECT_DISABLE_EFFECT)
	e3_2:SetReset(RESET_EVENT+0x1fe0000)
	sc:RegisterEffect(e3_2,true)
	Duel.SpecialSummonComplete()
end
--
function c11200069.con4(e,tp,eg,ep,ev,re,r,rp)
	return not re:GetHandler():IsSetCard(0x133)
end
--
function c11200069.tfilter4(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x133)
end
function c11200069.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(c11200069.tfilter4,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil)
	sg:AddCard(c)
	local tg=sg:Filter(Card.IsAbleToDeck,nil)
	if chk==0 then return tg:GetCount()>0 
		and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,tg,tg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
--
function c11200069.ofilter4(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x133) and c:IsAbleToDeck()
end
function c11200069.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(c11200069.ofilter4,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil)
	if c:IsRelateToEffect(e) then sg:AddCard(c) end
	Duel.SendtoDeck(sg,nil,1,REASON_EFFECT)
	Duel.Draw(tp,1,REASON_EFFECT)
end
--

