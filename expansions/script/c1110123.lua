--冥河絮语
local m=1110123
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
--
function c1110123.initial_effect(c)
--
	c:SetSPSummonOnce(1110123)
	aux.AddXyzProcedure(c,c1110123.xyzfilter,3,2,c1110123.ovfilter,aux.Stringid(1110123,0),2,c1110123.xyzop)
	c:EnableReviveLimit()
--  
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1110123,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c1110123.con1)
	e1:SetTarget(c1110123.tg1)
	e1:SetOperation(c1110123.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1110123,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c1110123.cost2)
	e2:SetTarget(c1110123.tg2)
	e2:SetOperation(c1110123.op2)
	c:RegisterEffect(e2)
--
end
--
function c1110123.xyzfilter(c)
	return c:IsType(TYPE_SPIRIT) 
end
function c1110123.ovfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPIRIT)
end
function c1110123.ofilter(c)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and c:IsFaceup()
end
function c1110123.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1110123.ofilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
end
--
function c1110123.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(c:GetSummonType(),SUMMON_TYPE_XYZ)~=0
end
--
function c1110123.tfilter1(c)
	return muxu.check_set_Soul(c)
end
function c1110123.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c1110123.tfilter1,tp,LOCATION_DECK,0,1,nil) and c:IsType(TYPE_XYZ) end
end
--
function c1110123.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local g=Duel.SelectMatchingCard(tp,c1110123.tfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
	end
end
--
function c1110123.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) end
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
end
--
function c1110123.tfilter2(c)
	return c:IsAbleToGrave()
end
function c1110123.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c1110123.tfilter2,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingTarget(c1110123.tfilter2,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectTarget(tp,c1110123.tfilter2,tp,LOCATION_ONFIELD,0,1,1,nil)
	local g2=Duel.SelectTarget(tp,c1110123.tfilter2,tp,0,LOCATION_ONFIELD,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g1,g1:GetCount(),0,0)
end
--
function c1110123.ofilter2(c)
	return muxu.check_set_Soul(c) and c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS)
end
function c1110123.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()<=0 then return end
	if Duel.SendtoGrave(tg,REASON_EFFECT)<=0 then return end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if c:IsHasEffect(EFFECT_NECRO_VALLEY) then return end
	if Duel.IsExistingMatchingCard(c1110123.ofilter2,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(1110123,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1110123,3))
		local gn=Duel.SelectMatchingCard(tp,c1110123.ofilter2,tp,LOCATION_GRAVE,0,1,1,nil)
		if gn:GetCount()<=0 then return end
		local tc=gn:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
--
