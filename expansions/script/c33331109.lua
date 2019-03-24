--神祭小狐 云狐神
if not pcall(function() require("expansions/script/c33331100") end) then require("script/c33331100") end
local m=33331109
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_BEAST),3)
	c:EnableReviveLimit()  
	local e1,e2=rsef.SV_LIMIT(c,"ress,resns",nil,nil,nil,"cd,uc")
	local e3,e4=rsef.SV_CANNOT_BE_MATERIAL(c,"fus,link",nil,nil,nil,"cd,uc")
	local e5=rsef.SC(c,EVENT_SPSUMMON_SUCCESS,nil,nil,"cd,uc",rscon.sumtype("link"),cm.op)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_BATTLED)
	e6:SetCondition(cm.damcon)
	e6:SetOperation(cm.damop)
	c:RegisterEffect(e6)
end
function cm.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker()==e:GetHandler() and Duel.GetAttackTarget() and Duel.GetAttackTarget():IsAttackAbove(1)
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	local bc=Duel.GetAttackTarget()
	if bc and bc:IsRelateToBattle() and bc:IsFaceup() then
		Duel.Hint(HINT_CARD,0,m)
		Duel.SetLP(1-tp,Duel.GetLP(1-tp)-bc:GetBaseAttack())
	end
end
function cm.op(e,tp)
	local c=e:GetHandler()
	local mat=c:GetMaterial():Filter(Card.IsSetCard,nil,0x2553)
	if #mat<=0 then return end
	for tc in aux.Next(mat) do 
		local buff=tc.lflist
		rslf.buffop(tc,c,buff,true)
	end
end
