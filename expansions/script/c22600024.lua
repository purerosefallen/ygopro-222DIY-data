--音语—二重奏之吉他×2
function c22600024.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,2,c22600024.spcheck)

	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22600024,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,22600024)
	e1:SetCondition(c22600024.rmcon)
	e1:SetTarget(c22600024.rmtg)
	e1:SetOperation(c22600024.rmop)
	c:RegisterEffect(e1)

	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22600024,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCountLimit(1,22600025)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_TOGRAVE)
	e2:SetTarget(c22600024.retg)
	e2:SetOperation(c22600024.reop)
	c:RegisterEffect(e2)
end

function c22600024.spcheck(g)
	return g:GetClassCount(Card.GetLevel)==g:GetCount() and g:GetClassCount(Card.GetLinkAttribute)==g:GetCount() and g:GetClassCount(Card.GetLinkRace)==1
end

function c22600024.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end

function c22600024.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end

function c22600024.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local g2=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
	if g1:GetCount()>0 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.Remove(sg1:GetFirst(),POS_FACEDOWN,REASON_EFFECT)
	end
	if g2:GetCount()>0 then
		local sg2=g2:RandomSelect(1-tp,1)
		Duel.Remove(sg2:GetFirst(),POS_FACEDOWN,REASON_EFFECT)
	end
end

function c22600024.refilter(c)
	return c:IsType(TYPE_MONSTER)
end

function c22600024.retg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then 
		return Duel.IsExistingTarget(c22600024.refilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingTarget(c22600024.refilter,tp,0,LOCATION_MZONE,1,nil) 
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectTarget(tp,c22600024.refilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectTarget(tp,c22600024.refilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g2,1,0,0)
end

function c22600024.reop(e,tp,eg,ep,ev,re,r,rp)
	local ex1,dg=Duel.GetOperationInfo(0,CATEGORY_TOGRAVE)
	local ex2,cg=Duel.GetOperationInfo(0,CATEGORY_REMOVE)
	local dc=dg:GetFirst()
	local cc=cg:GetFirst()
	if dc:IsRelateToEffect(e) and cc:IsRelateToEffect(e) then
		Duel.SendtoGrave(dc,REASON_EFFECT)
		Duel.Remove(cc,POS_FACEDOWN,REASON_EFFECT)
	end
end
