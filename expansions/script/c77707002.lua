--巴利索尔的孩子是独生子
local m=77707002
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end
function cm.filter(c,e,tp)
	if not Duel.IsExistingMatchingCard(function(c,tc)
		return c:GetOriginalCodeRule()==tc:GetOriginalCodeRule()
	end,tp,0,(LOCATION_GRAVE+LOCATION_MZONE)&(~c:GetLocation()),1,nil,c) or not c:IsType(TYPE_MONSTER) then return false end
	if c:IsLocation(LOCATION_GRAVE) then return c:IsCanBeSpecialSummoned(e,0,tp,true,false) and Duel.GetMZoneCount(tp)>0
	else return c:IsControlerCanBeChanged() end
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and chkc:GetControler()==1-tp
		and cm.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.filter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,1,nil,e,tp)
	if g:GetFirst():IsLocation(LOCATION_GRAVE) then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	else
		Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
	end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if tc:IsLocation(LOCATION_GRAVE) then
			Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
		elseif tc:IsLocation(LOCATION_MZONE) then
			Duel.GetControl(tc,tp)
		end
	end
end