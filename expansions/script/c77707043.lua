--庭园造景的少女
local m=77707043
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,function(c)
		return c:IsAttackBelow(0) and c:IsAttribute(ATTRIBUTE_DARK)
	end,1,1)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(m*16)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(SUMMON_TYPE_LINK)
	local mat_filter=function(c,lc)
		return c:IsCanBeLinkMaterial(lc) and c:IsAbleToRemoveAsCost() and c:IsCode(77707706)
	end
	e1:SetCondition(function(e,c)
		if c==nil then return true end
		if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
		local tp=c:GetControler()
		local mg=Duel.GetMatchingGroup(mat_filter,tp,LOCATION_GRAVE,0,nil,c)
		return aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_LMATERIAL) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and #mg>0
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp,c)
		local mg=Duel.GetMatchingGroup(mat_filter,tp,LOCATION_GRAVE,0,nil,c)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
		local g=mg:Select(tp,1,1,nil)
		c:SetMaterial(g)
		Duel.Remove(g,POS_FACEUP,REASON_MATERIAL+REASON_LINK)
	end)
	c:RegisterEffect(e1)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MINIATURE_GARDEN_GIRL)
	e1:SetValue(1)
	e1:SetTarget(function(e,c)
		return c:IsAttribute(ATTRIBUTE_DARK)
	end)
	c:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(0x14000)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
end
function cm.filter(c)
	return c:IsAttackBelow(0) and c:IsAbleToDeck() and not c:IsPublic()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp)
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(p,cm.filter,p,LOCATION_HAND,0,1,99,nil)
	if g:GetCount()>0 then
		Duel.ConfirmCards(1-p,g)
		local ct=Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		Duel.ShuffleDeck(p)
		Duel.BreakEffect()
		Duel.Draw(p,ct+1,REASON_EFFECT)
		Duel.ShuffleHand(p)
	end
end