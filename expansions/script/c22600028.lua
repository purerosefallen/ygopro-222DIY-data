--梦幻狂想曲
function c22600028.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c22600028.con)
	e1:SetCost(c22600028.cost)
	e1:SetTarget(c22600028.tg)
	e1:SetOperation(c22600028.op)
	c:RegisterEffect(e1)
end

function c22600028.con(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,EFFECT_LPCOST_CHANGE)
end

function c22600028.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,300) end
	local lp=Duel.GetLP(tp)
	local max=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
	local t={}
	local l=1
	while l<=max and l*300<=lp and l*300<=1500 do
		t[l]=l*300
		l=l+1
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(22600028,0))
	local announce=Duel.AnnounceNumber(tp,table.unpack(t))
	Duel.PayLPCost(tp,announce)
	e:SetLabel(announce/300)
end

function c22600028.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 end
end

function c22600028.op(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local g=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
	if g:GetCount()>0 then
		local tg=Duel.GetDecktopGroup(1-tp,ct)
		Duel.DisableShuffleCheck()
		Duel.Remove(tg,POS_FACEDOWN,REASON_EFFECT)
	end
end
