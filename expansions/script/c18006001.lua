--龙棋兵团 传令兵
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=18006001
local cm=_G["c"..m]
if not rsv.DCC then
	rsv.DCC={}
	rsdcc=rsv.DCC
function rsdcc.NormalMonsterFunction(c)
	local e3=rsef.QO(c,nil,{m,0},1,nil,"tg",LOCATION_MZONE,rsdcc.ncon2,nil,rstg.target({rsdcc.filter1,nil,LOCATION_ONFIELD,0,2}),rsdcc.mvop)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_TYPE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(rsdcc.ncon)
	e1:SetValue(TYPE_NORMAL)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_REMOVE_TYPE)
	e2:SetValue(TYPE_EFFECT)
	c:RegisterEffect(e2)
	return e3,e1,e2
end
function rsdcc.filter(c)
	return c:GetType()&TYPE_SPELL+TYPE_CONTINUOUS ==TYPE_SPELL+TYPE_CONTINUOUS and rsdcc.IsSet(c)
end
function rsdcc.filter0(c,rc)
	return c:GetType()&TYPE_SPELL+TYPE_CONTINUOUS ==TYPE_SPELL+TYPE_CONTINUOUS and c:IsFaceup() and rc:GetColumnGroup():IsContains(c)
end
function rsdcc.filter1(c,e,tp)
	return c:GetType()&TYPE_SPELL+TYPE_CONTINUOUS ==TYPE_SPELL+TYPE_CONTINUOUS and c:IsFaceup() and c:IsControler(tp)
end
function rsdcc.filter2(c)
	return c:IsAbleToGraveAsCost() and c:GetType()&TYPE_SPELL+TYPE_CONTINUOUS ==TYPE_SPELL+TYPE_CONTINUOUS and c:IsFaceup()
end
function rsdcc.ncon(e)
	return not Duel.IsExistingMatchingCard(rsdcc.filter0,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,e:GetHandler())
end
function rsdcc.ncon2(e)
	return Duel.IsExistingMatchingCard(rsdcc.filter0,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,e:GetHandler())
end
function rsdcc.mvop(e,tp)
	local g=rsgf.GetTargetGroup()
	if #g~=2 then return end
	Duel.ChangePosition(g,POS_FACEDOWN)
	local tc1=g:GetFirst()
	local tc2=g:GetNext()
	local seq1=tc1:GetSequence()
	local seq2=tc2:GetSequence()
	repeat
		Duel.ShuffleSetCard(g)
	until seq1~=tc1:GetSequence()
	Duel.ChangePosition(g,POS_FACEUP)
end
function rsdcc.QuickEffectFunction(c,code,cate,tg,op)
	local e1=rsef.QO(c,nil,{code,1},1,cate,nil,LOCATION_MZONE,rsdcc.ncon2,rscost.cost(rsdcc.filter2,"tg",LOCATION_ONFIELD),tg,op)
	return e1
end
function rsdcc.IsSet(c)
	return c:CheckSetCard("DragonChessCorps")
end
function rsdcc.tg(e,c)
	return e:GetHandler():GetColumnGroup():IsContains(c) and rsdcc.IsSet(c) and c:IsFaceup()
end
function rsdcc.tg2(e,c)
	return e:GetHandler():GetColumnGroup():IsContains(c) and not rsdcc.IsSet(c) and (e:GetLabel()==0 or c:IsType(e:GetLabel()))
end
function rsdcc.Activate(c,code,cate,op,tg2)
	local con=function(e,tp)
		return e:GetHandler():IsOnField()
	end
	local e1=rsef.ACT(c,nil,nil,{1,code},cate,"tg",con,nil,rstg.target(rsdcc.tfilter(tg2),nil,LOCATION_MZONE),op)
	return e1
end
function rsdcc.tfilter(tg2)
	return function(c,e,tp)
		return e:GetHandler():GetColumnGroup():IsContains(c) and rsdcc.IsSet(c) and (not tg2 or tg2(c,e,tp))
	end
end
---------------
end
---------------
if cm then
cm.rssetcode="DragonChessCorps"
function cm.initial_effect(c)
	local e1,e2,e3=rsdcc.NormalMonsterFunction(c)
	local e4=rsdcc.QuickEffectFunction(c,m,"se,th",rstg.target(rsop.list(cm.thfilter,"th",LOCATION_DECK)),cm.op)
end
function cm.thfilter(c)
	return c:IsAbleToHand() and rsdcc.IsSet(c)
end
function cm.op(e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #tg>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
---------------
end
