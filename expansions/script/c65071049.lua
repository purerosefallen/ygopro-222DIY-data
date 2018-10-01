--悲惨圣诞
function c65071049.initial_effect(c)
	--change effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65071049,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,65071049+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c65071049.condition)
	e1:SetOperation(c65071049.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(65071049,1))
	e2:SetCondition(c65071049.discon)
	e2:SetOperation(c65071049.disop)
	c:RegisterEffect(e2)
end
function c65071049.condition(e,tp,eg,ep,ev,re,r,rp)
	local ex2=re:IsHasCategory(CATEGORY_RECOVER)
	return ex2
end
function c65071049.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c65071049.repop)
end
function c65071049.repop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,1000,REASON_EFFECT)
end
function c65071049.discon(e,tp,eg,ep,ev,re,r,rp)
	local ex4=re:IsHasCategory(CATEGORY_DRAW)
	local ex5=re:IsHasCategory(CATEGORY_SEARCH)
	return (ex4 or ex5) and aux.exccon()
end

function c65071049.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c65071049.repop2)
end
function c65071049.repop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)<=0 then return end
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end