--暮色居城 嘲弄
function c65020050.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,99,c65020050.lcheck)
	c:EnableReviveLimit()
	--todeck
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c65020050.tdcon)
	e1:SetTarget(c65020050.tdtg)
	e1:SetOperation(c65020050.tdop)
	c:RegisterEffect(e1)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCondition(c65020050.reacon)
	e3:SetTarget(c65020050.reatg)
	e3:SetOperation(c65020050.reaop)
	c:RegisterEffect(e3)
end
function c65020050.lcheck(g)
	return g:IsExists(Card.IsLinkAttribute,1,nil,ATTRIBUTE_LIGHT) and g:IsExists(Card.IsLinkAttribute,1,nil,ATTRIBUTE_DARK)
end
function c65020050.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c65020050.tdfil(c)
	return c:IsFacedown() and c:IsAbleToDeck()
end
function c65020050.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65020050.tdfil,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_REMOVED)
end
function c65020050.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetMaterial()
	local num=0
	local tc=g:GetFirst()
	while tc do
		local lv=tc:GetLevel()
		num=num+lv
		tc=g:GetNext()
	end
	local nu=Duel.GetMatchingGroupCount(c65020050.tdfil,tp,LOCATION_REMOVED,0,nil)
	if nu<num then num=nu end
	local g=Duel.SelectMatchingCard(tp,c65020050.tdfil,tp,LOCATION_REMOVED,0,1,num,nil)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end

function c65020050.reafil(c,tp)
	return c:IsFacedown() and c:GetPreviousControler()==tp
end
function c65020050.reacon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c65020050.reafil,1,nil,tp)
end
function c65020050.reatg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroup(tp,0,1):IsExists(Card.IsAbleToRemove,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0)
end
function c65020050.abletoremove(c)
	return c:IsAbleToRemove() and not c:IsType(TYPE_TOKEN)
end
function c65020050.reaop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.GetFieldGroup(tp,0,1):IsExists(Card.IsAbleToRemove,1,nil) then return end
	local m=Duel.SelectOption(1-tp,aux.Stringid(65020050,0),aux.Stringid(65020050,1))
	if m==0 then
		local g1=Duel.SelectMatchingCard(1-tp,c65020050.abletoremove,1-tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil)
		Duel.HintSelection(g1)
		Duel.Remove(g1,POS_FACEDOWN,REASON_EFFECT)
	elseif m==1 then
		local g2=Duel.GetDecktopGroup(1-tp,1)
		Duel.DisableShuffleCheck()
		Duel.Remove(g2,POS_FACEDOWN,REASON_EFFECT)
	end 
end