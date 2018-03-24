--献上盛典压轴曲的莉昂
function c4210102.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,function(c)return c:IsFaceup()and c:IsRace(RACE_BEAST) and c:IsType(TYPE_MONSTER) end,4,2,function(c)return c:IsFaceup()and c:IsAttribute(ATTRIBUTE_FIRE)and c:IsType(TYPE_MONSTER) and c:GetOverlayCount()==3 and not c:IsCode(4210102) end,aux.Stringid(4210102,0))
	c:EnableReviveLimit()	
	--destroy replace
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(4210102,1))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c4210102.cost)
	e1:SetTarget(c4210102.target)
	e1:SetOperation(c4210102.operation)
	c:RegisterEffect(e1)	
	--boost
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x2ac))
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(function(e,c) return math.floor(Duel.GetMatchingGroupCount(function(c,e) return c:IsType(TYPE_MONSTER) end,c:GetControler(),LOCATION_GRAVE,0,nil)/5)*300 end)
	c:RegisterEffect(e2)
end
function c4210102.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c4210102.filter(c)
	return c:IsSetCard(0x2ac) and c:IsAbleToDeck()
end
function c4210102.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c4210102.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c4210102.filter,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c4210102.filter,tp,LOCATION_GRAVE,0,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c4210102.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA)
	local dg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
	if ct>0 and dg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local rg=dg:Select(tp,1,ct,nil)
		Duel.HintSelection(rg)
		Duel.SendtoDeck(rg,nil,2,REASON_EFFECT)
		Duel.Draw(1-tp,1,REASON_EFFECT)
	end
end